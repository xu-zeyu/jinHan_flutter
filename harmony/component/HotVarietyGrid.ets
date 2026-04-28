import { VarietyType } from '../../../api'
import { AssetsResource } from '../../../assets'

@ComponentV2
export struct HotVarietyGrid {
  @Param varietyList: VarietyType[] = []
  @Event onVarietyClick: (variety: VarietyType) => void = () => {
  }

  @Builder
  varietyItemBuilder(variety: VarietyType) {
    Column() {
      // 品种图片
      Image(variety.iconUrl)
        .width(58)
        .height(58)
        .objectFit(ImageFit.Fill)
        .borderRadius(12)

      // 品种名称
      Text(variety.name)
        .fontSize(11)
        .fontColor('#333333')
        .fontWeight(500)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 6 })
        .width('100%')
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.onVarietyClick(variety)
    })
  }

  build() {
    Column() {
      // 标题
      Row() {
        Text('热门宠物')
          .fontSize(14)
          .fontWeight(600)
          .fontColor('#1a1a1a')

        Blank()

        Row(){
          Text('查看更多')
            .fontSize(11)
            .fontColor('#999')

          Image(AssetsResource.btn_more_icon).width(16).height(16).fillColor(Color.Black).margin({top: -2})
        }
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          // 点击查看更多
        })

      }
      .width('100%')
      .height(24)
      .alignItems(VerticalAlign.Center)

      // 品种网格
      Grid() {
        ForEach(this.varietyList, (variety: VarietyType) => {
          GridItem() {
            this.varietyItemBuilder(variety)
          }
        }, (variety: VarietyType) => variety.id.toString())
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsGap(8)
      .width('100%')
    }
    .width('100%')
    .backgroundColor(Color.White)
  }
}
