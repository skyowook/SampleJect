//
//  TagCollectionView.swift
//  TestProject
//
//  Created by IMC056 on 2018. 4. 17..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit


protocol TagViewDelegate : NSObjectProtocol {
    /// 태그 삭제
    ///
    /// - Parameters:
    ///     - tagView: 태그 뷰
    ///     - indexPath: 삭제된 태그 인덱스
    ///     - text: 태그 텍스트
    func tagView(_ tagView: TagView, deletedTagAt indexPath: IndexPath, tagText text: String?)
    
    /// 태그 터치
    ///
    /// - Parameters:
    ///     - tagView: 태그 뷰
    ///     - indexPath: 터치된 태그 인덱스
    ///     - text: 태그 텍스트
    func tagView(_ tagView: TagView, touchTagAt indexPath: IndexPath, tagText text: String?)
}

// MARK: - TagView
/// 태그 뷰
class TagView: UICollectionView {
    // MARK: - Variable
    private static let DEFAULT_TAG_LINE_SPACING: CGFloat = 10       // 기본 라인 간격
    private static let DEFAULT_TAG_SPACING: CGFloat = 10            // 기본 태그 간격
    
    private static let REUSE_IDENTIFIER = "TagCell"         // 태그 재사용 식별자
    
    var tagLineSpacing: CGFloat = DEFAULT_TAG_LINE_SPACING  // 태그 라인 간격
    var tagSpacing: CGFloat = DEFAULT_TAG_SPACING           // 태그 간격
    
    var guideTag: BaseTagCell? = nil                // 가이드 태그 (태그 크기 구하기용)
    
    var tags: [String]? = nil           // 태그들
    var selectedTags: [Int:String?] = [Int:String?]() // 선택된 태그들
    
    var tagViewDelegate: TagViewDelegate?           // 태그 뷰 델리게이트
    
    // MARK: - Override Func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dataSource = self
        self.delegate = self
        
        if let flowLayout = self.collectionViewLayout as? TagViewFlowLayout {
            flowLayout.delegate = self
        }
    }

    /// 태그로 사용될 nib 등록 BaseTagCell을 상속받지 않은 Cell은 등록되지 않고 false 반환, 성공적인 등록시 true 반환
    ///
    /// - Parameter nib: 등록 할 태그 Nib
    /// - Returns: 등록 여부
    func registerTag(_ nib: UINib?) -> Bool {
        if let tag = nib?.instantiate(withOwner: nil, options: nil)[0] as? BaseTagCell {
            guideTag = tag
            
            self.register(nib, forCellWithReuseIdentifier: TagView.REUSE_IDENTIFIER)
            
            return true
        }
        
        return false
    }
    
    /// 태그 재사용
    ///
    /// - Parameter indexPath: 재사용 될 태그 인덱스 패스
    /// - Returns: 재사용 될 태그
    func dequeueReuseableTag(forIndexPath indexPath: IndexPath) -> BaseTagCell? {
        let cell = self.dequeueReusableCell(withReuseIdentifier: TagView.REUSE_IDENTIFIER, for: indexPath) as? BaseTagCell
        
        cell?.delegate = self
        
        return cell
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

// MARK: - 태그 델리게이션
extension TagView: TagCellDelegate {
    func deleteTagCell(_ tagCell: BaseTagCell) {
        if let deleteIndexPath = self.indexPath(for: tagCell) {
            tags?.remove(at: deleteIndexPath.item)
            self.deleteItems(at: [deleteIndexPath])
            
            if let del = tagViewDelegate {
                del.tagView(self, deletedTagAt: deleteIndexPath, tagText: tagCell.getTagText())
            }
        }
    }
    
    func selectTagCell(_ tagCell: BaseTagCell) {
        if let selectIndexPath = self.indexPath(for: tagCell) {
            selectedTags[selectIndexPath.item] = tagCell.getTagText()
        }
    }
    
    func deselectTagCell(_ tagCell: BaseTagCell) {
        if let deselectIndexPath = self.indexPath(for: tagCell) {
            selectedTags.removeValue(forKey: deselectIndexPath.item)
        }
    }
    
    func touchTag(_ tagCell: BaseTagCell) {
        if let touchTagIndexPath = self.indexPath(for: tagCell) {
            
            if let del = self.tagViewDelegate {
                del.tagView(self, touchTagAt: touchTagIndexPath, tagText: tagCell.getTagText())
            }
        }
    }
}

// MARK: - DataSource
extension TagView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tags = self.tags {
            return tags.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let tag = dequeueReuseableTag(forIndexPath: indexPath) {
            tag.initTag()
            
            if let tags = self.tags {
                tag.setTagText(tags[indexPath.item])
            }
            
            return tag
        }
        
        return UICollectionViewCell()
    }
}

// MARK: - Delegate
extension TagView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return tagLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return tagSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let guideTag = self.guideTag, let tags = self.tags {
            return guideTag.getTagSize(withTagString: tags[indexPath.row])
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}
