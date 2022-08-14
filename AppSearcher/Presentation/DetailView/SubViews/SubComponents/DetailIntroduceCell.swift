//
//  DetailIntroduceCell.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/13.
//

import UIKit

protocol DetailIntroduceCellDelegate: AnyObject {
    func updateLayout()
}

final class DetailIntroduceCell: UICollectionViewCell {
    
    // MARK: Properties
    weak var delegate: DetailIntroduceCellDelegate?
    static var reuseIdentifier: String { "DetailIntroduceCell" }
    private var isSpreadOut: Bool = false {
        didSet {
            let title = isSpreadOut ? "접기" : "자세히 보기"
            foldableButton.setTitle(title, for: .normal)
        }
    }
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.text = "Backpackr Inc."
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        return label
    }()
    
    private lazy var foldableButton: UIButton = {
        let button = UIButton()
        button.setTitle("자세히 보기", for: .normal)
        button.setTitleColor(UIColor.primary, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .bold)
        button.addTarget(self, action: #selector(foldableButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let bottomShadowLayer = CALayer.createBottomShadowLayer()
    private lazy var contentsHeightConstraint = contentsLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 0)
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
        addShadowLayer()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setShadowLayerPath()
    }
    
    // MARK: Actions
    @objc
    private func foldableButtonHandler() {
        contentsLabel.numberOfLines = isSpreadOut ? 4 : 0
        if let text = contentsLabel.attributedText?.string {
            setContentsLabelText(text)
            isSpreadOut = !isSpreadOut
        }
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 13.0
        contentView.clipsToBounds = true
    }
    
    private func layout() {
        contentView.addSubview(artistLabel)
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: artistLabel, attribute: .top, relatedBy: .equal,
                toItem: contentView, attribute: .top, multiplier: 1.0, constant: 22.0),
            NSLayoutConstraint(
                item: artistLabel, attribute: .left, relatedBy: .equal,
                toItem: contentView, attribute: .left, multiplier: 1.0, constant: 20.0),
        ])
        
        contentView.addSubview(contentsLabel)
        contentsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: contentsLabel, attribute: .top, relatedBy: .equal,
                toItem: artistLabel, attribute: .bottom, multiplier: 1.0, constant: 20.0),
            NSLayoutConstraint(
                item: contentsLabel, attribute: .left, relatedBy: .equal,
                toItem: artistLabel, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: contentsLabel, attribute: .right, relatedBy: .lessThanOrEqual,
                toItem: contentView, attribute: .right, multiplier: 1.0, constant: -20.0),
            contentsHeightConstraint,
        ])
        
        contentView.addSubview(foldableButton)
        foldableButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: foldableButton, attribute: .top, relatedBy: .equal,
                toItem: contentsLabel, attribute: .bottom, multiplier: 1.0, constant: 5.5),
            NSLayoutConstraint(
                item: foldableButton, attribute: .centerX, relatedBy: .equal,
                toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: foldableButton, attribute: .bottom, relatedBy: .equal,
                toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -8.5),
            foldableButton.heightAnchor.constraint(equalToConstant: 44.0)
        ])
    }
    
    private func addShadowLayer() {
        self.layer.insertSublayer(bottomShadowLayer, at: 0)
    }
    
    private func setShadowLayerPath() {
        bottomShadowLayer.shadowPath = UIBezierPath(
            roundedRect: contentView.bounds,
            cornerRadius: contentView.layer.cornerRadius
        ).cgPath
    }
    
    private func getContentsNSAtrributedString(text: String) -> NSAttributedString {
        let paragraphSytle = NSMutableParagraphStyle()
        paragraphSytle.lineBreakMode = .byTruncatingTail
        paragraphSytle.lineSpacing = 5.0
        paragraphSytle.alignment = .left
        return NSMutableAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 16.0, weight: .medium),
                .paragraphStyle: paragraphSytle,
            ])
    }
    
    private func calculateEstimatedHeight() -> CGFloat {
        let width = UIScreen.main.bounds.width - 80.0
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let estimatedHeight = contentsLabel.sizeThatFits(size).height
        guard contentsLabel.numberOfLines > 0 else { return estimatedHeight }
        
        let lineHeight: CGFloat = 23.0
        let restrictedHeight = lineHeight * CGFloat(contentsLabel.numberOfLines)
        return restrictedHeight > estimatedHeight ? estimatedHeight : restrictedHeight + 12
    }
    
    private func setContentsLabelText(_ text: String) {
        let attributedText = getContentsNSAtrributedString(text: text)
        contentsLabel.attributedText = attributedText
        contentsHeightConstraint.constant = calculateEstimatedHeight()
        delegate?.updateLayout()
    }
}

// MARK: - Bind
extension DetailIntroduceCell {
    func bind() {
        let text = "◎ 대한민국 모바일 앱 어워드 대상 수상! ◎\n\n아이디어스는 아시아 최대의 핸드메이드 라이프스타일 플랫폼입니다. 핸드메이드를 통한 취향 탐색과 맞춤 작품 구매, 일상이 풍요로워지는 핸드메이드 문화생활까지! 아이디어스로 한 번에 누려보세요.\n\n■ 이야기가 담긴 작품을 만나보세요\n\n어디를 가도 비슷한 패션, 찍어낸 듯한 인테리어, 원산지를 알 수 없는 인스턴트 식품... 똑같이 사는 매일에 지치셨나요?\n\n산지직송 신선함이 함께 배송되는 농축수산물, 커플만의 특별한 메시지를 새긴 텀블러, 당신만의 시간이 묻는 가죽 지갑까지! 대량생산 공산품 대신 작가님의 이야기가 담긴 42만여 개 작품으로 일상에 특별함을 더해보세요. 구경만 해도 시간 가는 줄 모를 거에요.\n\n■ 취향저격 작가님과 소통하세요\n\n독창적인 아이디어가 작품이 되는 곳. 아이디어스에는 판매자 대신 3만 여명의 작가님이 당신을 기다립니다.\n\n취향저격 작가님을 팔로우하고, 1:1 메시지와 스토리로 작가님과 소통하면서 당신만의 이야기가 담긴 작품을 만들어보세요. \n\n■ 특별한 할인 혜택을 만나보세요\n\n풍요로운 핸드메이드 라이프를 위한 할인 혜택도 놓치지 마세요. \n- 매일 0시에 찾아오는 타임세일 '오늘만 할인'\n- 매주 금요일 신규 작가님을 소개하는 '입점할인'\n- 매월 통 크게 선보이는 '월 할인'\n- 월 2500원에 무제한 무료배송 'VIP 클럽'\n\n■ 오늘의 취미를 골라보세요\n\n핸드메이드 라이프, 작품 구매를 넘어 직접 체험해보고 싶다면?\n매주 업데이트되는 신상 취미를 무제한 스트리밍으로 즐겨보세요. (2주 체험도 가능) 검증된 아이디어스 작가님의 고퀄리티 취미 클래스를 스마트폰, PC 어디서나. 원하는 곳에서 오늘의 취미를 시작하세요.\n\n아이디어스와 함께 특별한 핸드메이드 라이프를 만들 준비되셨나요?\n\n■ 페이스북, 인스타그램, 유튜브에서도 아이디어스를 만나볼 수 있습니다. '아이디어스'를 검색해 주세요~ 기다리고 있을게요!\n\n■ 카카오톡 친구로 추가하면 쿠폰까지 드려요!\n친구찾기 에서 \"아이디어스\" 검색\n\n■ 고객센터 (평일 오전 10시 ~ 오후 6시)\n[대표번호] 1668-3651\n[E-mail] support@backpac.kr"
       
       setContentsLabelText(text)
    }
}
