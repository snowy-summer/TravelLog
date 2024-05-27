# TravelLog 1.0.0

- 여행의 경험을 기록하는 앱
https://apps.apple.com/us/app/travellog/id6503001417

### 기술스택
- UIKit
- mvvm
- MapKit
- CoreData


### 타겟 버전
- ios 16 ( 2024 기준 ios 16이상 90% )

<img width="378" alt="Untitled" src="https://github.com/snowy-summer/TripLog/assets/118453865/2bf54d6f-4aaf-4b86-b153-0792b8776dfa">


### 앱 화면
| 화면 1 | 화면 2 | 화면 3 | 화면 4|
| --- | --- | --- | --- |
| <img src="https://github.com/snowy-summer/TripLog/assets/118453865/09a6d84f-0f49-4c4a-af51-29f7791a89f6" width="300" height="400"> | <img src="https://github.com/snowy-summer/TripLog/assets/118453865/872adc03-b023-47b2-87e2-49b5df1a27c1" width="300" height="400"> | <img src="https://github.com/snowy-summer/TripLog/assets/118453865/a895393f-afe5-4758-87ee-e56e9282bce2" width="300" height="400"> | <img src="https://github.com/snowy-summer/TripLog/assets/118453865/6272ab0e-3642-4772-815a-a8526c77f90d" width="300" height="400"> |

## 회전하는 collectionView를 위한 공부

- collection View를 만들 때 layout 객체를 설정한다. 하지만 collection view의 layout은 변경이 가능하다.
    
    ```swift
       init(frame: CGRect, mainViewModel: MainViewModelProtocol) {
            self.mainViewModel = mainViewModel
            super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
            self.register(MainCardCell.self,
                          forCellWithReuseIdentifier: MainCardCell.identifier)
            self.collectionViewLayout = createBasicCompositionalLayout()
        }
    ```
    
    - UIcollecitonViewLayout()에서 createBasicCompositionalLayout으로 변경하는 모습
    - 이 경우에는 애니메이션 없이 즉시 layout이 변경이 된다.
    - 애니메이션이 필요하면 setCollectionViewLayout(_:animated:completion: )을 사용해야한다.

<img width="400" src="https://github.com/snowy-summer/TripLog/assets/118453865/4d3b2862-d3d5-4937-bb62-5f0a5173698b">


## Custom Collection View Layout

- UICollectionView의 subclass를 생성한다.
- 이 클래스의 모든 item들의 visual attributes를 명시해야 한다,
    - itemSize ( item의 사이즈)
    - radius ( 원형을 만들 반지름)
    - anglePerItem (어느 정도의 각도로 item을 배치할 것인지
- 이 클래스에서 사용하는 attributes는 UICollectionViewLayoutAttributes의 인스턴스다.

### invalidateLayout

- invalidateLayout은 reloadData와 다르게 변경된 데이터는 적용이 안되고 layout만 변경이 된다.
- invalidateLayout은 즉시 업데이트가 아닌 다음 view의 update Cycle에 수행된다
- 이 메서드를 override하는 경우, super를 호출해줘야 한다.

### PrePare

- 기본 구현은 아무 작업도 수행하지 않는다.
- override하여 레이아웃을 수행하는 데 필요한 데이터 구조를 설정하거나 초기 계산을 수행할 수 있다.

- prepare 내부 코드 설명
    
    ```swift
    let centerX = collectionView.contentOffset.x + (CGRectGetWidth(collectionView.bounds) / 2.0)
    ```
    
    - 움직인 화면 + 보이는 화면의 중앙
    - contentOffSet:  총 content.origin에서 보이는 화면까지의 거리
    - 그렇기 때문에 사용자 입장에서 항상 화면의 중앙에 위치하게 된다.
    
 
<img width="300" src="https://github.com/snowy-summer/TripLog/assets/118453865/294df81a-05cc-465d-a7f8-d929bbf4a900">
    

### CollectionViewContentSize

- collectionView content의 size를 반환하는데 사용
- 현재 보이는 모든 콘텐츠가 아닌 모든 content의  size를 반환한다.
- 기본 값은 CGSizeZero를 반환한다.

### layoutAttributesClass

- UICollectionViewLayoutAttributes의 서브클래스를 사용하는 경우 이 메서드를 override하고 서브 클래스를 반환해야 한다.
- 새롭게 layout attributes를 생성하는 경우 이 메서드를 사용한다.
- 이 메서드는 서브 클래스 전용이므로, 코드에서 호출할 필요가 없다.

```swift
  override class var layoutAttributesClass: AnyClass {
        return CircularLayoutAttributes.self
    }
```

### layoutAtrributesForItem

- 레이아웃을 처음 생성하거나, cell을 재사용, cell에 대한 레이아웃을 다시 계산하는 경우 호출
- 해당 cell이 있는 항목에 대한 layout정보를 제공한다.
- supplemetary view또는 decoration view에는 사용을 하지 말자

```swift
UICollectionViewLayoutAttributes? {
    return attributesList[indexPath.row]
}
```

### layoutAttributesForElements

- 서브 클래스는 이 메서드를 override하여 view가 지정된 사각형과 교차하는 모든 항목에 대한 레이아웃 정보를 반환할 때 사용해야 한다.
- layout을 생성하거나 업데이트 하는 경우 보여지는 범위 내의 모든 셀과 뷰에 대한 레이아웃의 속성을 한꺼번에 얻는다.
- 스크롤하는 경우 호출도 된다.

```swift
 override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return attributesList
 }
```

### shouldInvalidateLayout

- 새로운 업데이트가 필요한지 확인한다.
- 기본적으로 false를 반환
- collection View의 bound가 변경이 되고 true를 반환하는 경우 collection View는 invalidateLayout을 호출

<img width="300" src="https://github.com/snowy-summer/TripLog/assets/118453865/1e97b623-ed70-4860-bf9c-b321ceedf3fb">
- radius : 회전의 중심에서의 거리
- anglePerItem : item간의 각도

- angleAtExtreme : 드래그 했을 때 첫 번째 cell의 각도
    
    
  <img width="400" src="https://github.com/snowy-summer/TripLog/assets/118453865/398ff9e8-4a2c-4dd4-a6b5-4e9468cbd66e">
  
    - 마지막 cell의 각도가 0이여야 한다.
    - 컴퓨터 수식 말고 일반적인 수식으로 이야기 하자면
    - `첫번째 cell의 각도 + anglePerItem * ( cell의 숫자 - 1 ) = 마지막 cell의 각도`
    - 스크롤을 할 시에 끝까지 스크롤을 하면 마지막 cell이 0도 여야 한다.
    - 그러면 `첫번째 cell 각도 + anglePerItem * ( cell의 숫자 - 1) = 0`
    - `첫번째 cell 각도 = - anglePerItem * (cell의 숫자 - 1)`
    - 근데 이러면 첫번째 cell이 0도 일때는  `마지막 cell각도 = anglePerItem * ( cell의 숫자 - 1 )`
    - 마지막 cell이 0도 일때는 `첫번째 cell 각도 = - anglePerItem * (cell의 숫자 - 1)` 이렇게 나온다.
    
    ```swift
    var angleAtExtreme: CGFloat {
        
        guard let collectionView = collectionView else { return 0.0}
        
        if collectionView.numberOfItems(inSection: 0) > 0 {
            return -CGFloat(collectionView.numberOfItems(inSection: 0) - 1) * anglePerItem
            
        }
        // 스크롤을 끝까지 했을 때 첫 번째 cell의 각도
        
        return 0.0
    }
    ```
    
    - 스크롤 했을시 첫 번째 cell의 각도
        
<img width="300" src="https://github.com/snowy-summer/TripLog/assets/118453865/9db1fde4-cf13-4a1c-a259-308515b832d8">
        

- 최적화 : 화면에 보이는 cell들만 계산을 해준다.
    
    
<img width="300" src="https://github.com/snowy-summer/TripLog/assets/118453865/c7247d9d-a429-4b3a-bc63-a60348044ef2">

 - collection View가 있을 때 화면에 보이는 cell들을 계산해준다.
    
<img width="300" src="https://github.com/snowy-summer/TripLog/assets/118453865/0347e847-dc47-481e-b37a-3fdbaa5169b6">


    
- CircularLayout 코드
    
    ```swift
    //
    //  CircularLayout.swift
    //  TripLog
    //
    //  Created by 최승범 on 2024/03/07.
    //
    
    import UIKit
    
    final class CircularLayout: UICollectionViewLayout {
        
        var attributesList = [CircularLayoutAttributes]()
        let itemSize: CGSize
        
        var radius: CGFloat {
            didSet {
                // 반지름이 변경되면 다시 계산하도록
                invalidateLayout()
                // invalidateLayout은 reloadData와 다르게 변경된 데이터는 적용이 안되고 layout만 변경이 된다.
                // invalidateLayout은 즉시 업데이트가 아닌 다음 view의 update Cycle에 수행된다,
                // 이메서드를 override하는 경우, super를 호출해줘야 한다.
            }
        }
        
        var anglePerItem: CGFloat {
            return atan(itemSize.width / radius)
            //왜 width??
        }
        
        var angleAtExtreme: CGFloat {
            
            guard let collectionView = collectionView else { return 0.0}
            
            if collectionView.numberOfItems(inSection: 0) > 0 {
                return -CGFloat(collectionView.numberOfItems(inSection: 0) - 1) * anglePerItem
                
            }
            // 스크롤을 끝까지 했을 때 첫 번째 cell의 각도
            
            return 0.0
        }
        
        var angle: CGFloat {
            // 드래그 했을 때 angle
            guard let collectionView = collectionView else { return 0.0 }
            let extraContentWidth = collectionViewContentSize.width - CGRectGetWidth(collectionView.bounds)
            let angle = angleAtExtreme * collectionView.contentOffset.x / extraContentWidth
            
            return angle
        }
        
        //UICollectionViewLayoutAttributes의 서브클래스를 사용하는 경우 이 메서드를 override하고 서브 클래스를 반환해야 한다.
        override class var layoutAttributesClass: AnyClass {
            return CircularLayoutAttributes.self
        }
        
        init(itemSize: CGSize, radius: CGFloat) {
            self.itemSize = itemSize
            self.radius = radius
            super.init()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    }
    
    extension CircularLayout {
        
        override func prepare() {
            super.prepare()
            
            guard let collectionView = collectionView else { return }
            let collectionViewWidth = CGRectGetWidth(collectionView.bounds)
            let collectionViewHeight = CGRectGetHeight(collectionView.bounds)
            let centerX = collectionView.contentOffset.x + (collectionViewWidth / 2.0)
            //움직인 화면 + 보이는 화면의 중앙
            // contentOffset은 스크롤 뷰(사용자가 보는 뷰)의 origin과 contentVie의 origin의 떨어진 정도
            let itemCount = collectionView.numberOfItems(inSection: 0)
            
            let anchorPointY = (itemSize.height / 2.0 + radius) / itemSize.height
            //왜 itemSize.height로 나눠야 하는 거지?????
            // 그냥 적정 비율인듯 하다. 1만 넘어가면 회전하는 축이 화면 아래에 위치하기 때문에 상관은 없다.
    //        let anchorPointY = 2.5
            
            attributesList = (0..<itemCount).map { (i) ->
                CircularLayoutAttributes in
                
                let attributes = CircularLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
                
                attributes.size = self.itemSize
                
                attributes.center = CGPoint(x: centerX,
                                            y: CGRectGetMidY(collectionView.bounds))
                
                attributes.angle = self.angle + (self.anglePerItem * CGFloat(i))
                attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
                
    
                
                return attributes
            }
        }
        
        override var collectionViewContentSize: CGSize {
            guard let collectionView = collectionView else { return CGSize()}
            let width = CGFloat(collectionView.numberOfItems(inSection: 0)) * itemSize.width
            let height = CGRectGetHeight(collectionView.bounds)
            // 왜 높이를 collectionView와 동일시 하지?
            // 높이가 똑같아야지 좌우로 드래그 하기 때문
            
            return CGSize(width: CGFloat(width), height: height)
        }
        
        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            // 서브 클래스는 이 메서드를 override하여 view가 지정된 사각형과 교차하는 모든 항목에 대한 레이아웃 정보를 반환할 때 사용해야 한다
            return attributesList
        }
        
        override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            //cell을 재사용하거나 cell에대한 레이아웃을 다시 계산해야 하는 경우 호출, 레이아웃을 처음 생성하거나
            // 해당 cell이 있는 항목에 대한 layout정보를 제공한다.
            // supplementary view 또는 decoration view에는 사용을 하지 말자
            return attributesList[indexPath.row]
        }
        
        override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
            // 새로운 레이아웃 업데이트가 필요한지 확인
            return true
        }
    }
    
    ```
    
- CircularAttributes
    
    ```swift
    //
    //  CircularAttributes.swift
    //  TripLog
    //
    //  Created by 최승범 on 2024/03/07.
    //
    
    import UIKit
    
    final class CircularLayoutAttributes: UICollectionViewLayoutAttributes {
        
        var anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
        //회전하는 기준점
        
        var angle: CGFloat = 0 {
            didSet {
                zIndex = Int(angle * 100000)
                //z축에서 항목의 위치
                transform = CGAffineTransformMakeRotation(angle)
                // angle의 각도만큼 회전
            }
        }
    
        convenience init(anchorPoint: CGPoint, forCellWith: IndexPath) {
            self.init(forCellWith: forCellWith)
            self.anchorPoint = anchorPoint
        }
        
        //CollectionViewLayoutAttributes가 NSCopying를 채택하고 있다.
        override func copy(with zone: NSZone? = nil) -> Any {
            let copiedAttributes = super.copy(with: zone) as! CircularLayoutAttributes
            
            copiedAttributes.anchorPoint = self.anchorPoint
            copiedAttributes.angle = self.angle
            
            return copiedAttributes
        }
    }
    
    ```
    
- cell
    
    ```swift
    final class SubCardCell: UICollectionViewCell {
        
        static let identifier = "SubCardCell"
        
        override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
            super.apply(layoutAttributes)
            
            guard let circularLayoutAttributes = layoutAttributes as? CircularLayoutAttributes else { return }
            self.layer.anchorPoint = circularLayoutAttributes.anchorPoint
            self.center.y += (circularLayoutAttributes.anchorPoint.y - 0.5) * CGRectGetHeight(self.bounds)
            // 이해 안가는 부분
        }
    }
    
    ```
# 트러블 슈팅

1. 메모리 해제가 안되는 문제
- 16버전

| 메모리 해제가 안되는 과정 |
| --- |
| ![modal메모리 문제](https://github.com/snowy-summer/TripLog/assets/118453865/a313b000-6498-44c8-9c82-373490bcb525)|

| 과정 후의 메모리 그래프 | 메모리 그래프 2 |
| --- | --- |
|![image](https://github.com/snowy-summer/TripLog/assets/118453865/92b56f26-e78d-4f21-8fe5-3385934e0653) | ![image](https://github.com/snowy-summer/TripLog/assets/118453865/54fb44a8-601d-4bbd-9f01-4f3f4ab0f94e) |
<br/>
- 17버전

| ios 17 메모리 생존해 있을 때 메모리 그래프 |
| --- |
| ![image](https://github.com/snowy-summer/TripLog/assets/118453865/e55fc3da-9f97-4125-aa43-b4bdf7c9b4af) |

- 메모리에 생존해 있을 때 참조하는 항목이 MapViewController와 UINavigationContorller만 존재


- 똑같은 과정을 실행하였다.
- 16 버전 deinit이 호출이 안된다.
- instrument의 leak검사를 한 결과 메모리 누수는 없다고 나온다.
- 메모리 그래프를 살펴본 결과  modal로 표시한 뷰컨트롤러의 sheetPageController가 참조를 계속 유지 한다고 나온다.
- 코드를 살펴 본 결과 참조를 유지할 이유가 없다는게 결론이였다.
- 그래서 ios 17로 살펴본 결과, 17 버전은 deinit이 호출이 된다.
- 왜 15,16은 메모리 해제가 안되고 17버전은 메모리 해제가 될까? 라는 의문을 가졌고 ios의 업데이트 때 수정된 버그라고 생각된다.
<br/>
해결 방안

- 처음에는 뷰 컨트롤러를 그대로 사용하고 모달처럼 보여주려 했다. 달을 구현하는 방식은 frame의 변경을 생각을 했고 간단하게 구현을 해서 테스트를 했다.
- 문제는 뒤에 있는 viewController를 터치 할 수 없다는 문제였다. 뒤에 있는 viewController에 mapView가 있기 때문에 무조건 터치가 가능해야 한다.
    - 이것에 대한 해결책으로 hitTest와 dimmingView를 제거하는 방법을 생각했다.
    - hitTest는 view간에는 가능하지만 viewController끼리는 불가능한 것 같다.
    - dimmingView를 제거해도 transitionView가 막고 있어서 뒤에 있는 viewController를 터치하는 방법을 찾지 못했다.
    
| 검은색뒤에 있는 view들 |
| --- |
| ![image](https://github.com/snowy-summer/TripLog/assets/118453865/f8dc537a-3444-4d39-84c0-b79f76886e89) |


    
- 그렇다면 기존의 모달로 보여주는 viewController를 어떻게 보여줄까 고민을 하다가 viewController → view로 변경시켜서 손가락의 움직임에 따라 변할 수 있고 모달처럼 보이는 뷰를 만들기로 결정했다.
- view에 panGesture를 추가하여서 panGesture로 받아오는 좌표를 계산해서 constarint를 변경을 해주는 방법을 이용했다.
    - 이러한 방법을 이용하면 동일한 viewController이기 때문에 mapView를 터치하는데 아무런 문제가 없었다.


| 결과 |
| --- |
| ![모달구현](https://github.com/snowy-summer/TripLog/assets/118453865/a3d14379-2f75-4da2-bd3a-14673e6f116b) |


<br/>
2. 검색하는 경우 너무 많은 request요청

- 서치바에 입력을 하는 경우 collectionView의 cell에 해당 장소가 어떤 장소인지 간단한 이미지를 보여 주기 위해
- mapItem이라는 값을 얻어야 하는데 이 mapItem은 request를 요청해야 얻는 것이 가능해진다.
- mapItem을 사용안하고 그냥 자동 검색을 완성하는 것이 가능하지만 아이콘을 보여주기 위해서는 mapItem을 받아와야했다.
- 받아오는 경우 search bar의 글자가 변경될때마다 request를 보내기 때문에 너무 많은 호출이 된다.
- 그로 인해 request를 강제로 멈춰버리는 현상이 발생한다.
- 호출을 줄이는 방법으로 debounce와 throttle이라는 키워드를 알게되었고 공부를 진행했다.

- 일단 combine을 사용하거나 GCD, async등을 사용하는 방법이 존재한다.

- Debounce
    - 예시) debounce를 5초를 걸어 놓으면 마지막 이벤트가 발생하고 나서 5초 뒤에 발생한다.
    - 주로 검색 입력 같은 곳에 사용한다.
    - 검색 입력은 입력하는 경우에 자동완성을 하는 편인데 모든 입력에 자동 완성을 한다면 한 글자를 입력 할때 마다 요청이 필요하기 때문에 글자 입력이 순간적으로 멈췄을 때 검색을 실행해주면 된다.
    


- Throttle
    - 예시) throttle을 5초로 설정하면 이벤트가 발생했을때 첫 번째 이벤트가 5초뒤에 발생
    - 연속적으로 발생하는 이벤트에서, 일정 시간 간격으로 이벤트를 실행

| debounce | throttle |
| --- | --- |
| <img src="https://github.com/snowy-summer/TripLog/assets/118453865/9a5ec6aa-26ea-4b0e-9b17-8d0ce2a5b807" width="300" height="600"> | <img src="https://github.com/snowy-summer/TripLog/assets/118453865/057f34a2-02ed-4e99-860a-93ff329cae34" width="300" height="600"> |

- GCD를 이용해서 구현을 했다.

```swift
final class Debouncer {
    
    private let mainQueue = DispatchQueue.main
    private var workItem: DispatchWorkItem?
    private let seconds: Double
    
    init(seconds: Double) {
        self.seconds = seconds
    }
    
    func run(closure: @escaping () -> ()) {
        workItem?.cancel()
        
        let newWorkItem = DispatchWorkItem(block: closure)
        workItem = newWorkItem
        
        mainQueue.asyncAfter(deadline: .now() + seconds,
                             execute: newWorkItem)
    }
}
```

- 이 과정을 통해 기존의 많은 request를 보내는 방법을 수정했다.

| 전 | 후 |
| --- | --- |
| <img src="https://github.com/snowy-summer/TripLog/assets/118453865/dc123e80-9be4-489e-a648-947f1bfecc62" width="300" height="600"> | <img src="https://github.com/snowy-summer/TripLog/assets/118453865/e3181990-fb8c-47a2-af6f-10396290ccf5" width="300" height="600"> |


