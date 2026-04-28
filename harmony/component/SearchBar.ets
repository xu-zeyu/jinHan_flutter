import { WindowSizeWrapper } from "../../../utils";
import { AppStorageV2 } from "@kit.ArkUI";

@ComponentV2
export default struct SearchBar {
  @Param @Require bgOpacity:number; // 背景透明度
  @Local storage: WindowSizeWrapper = AppStorageV2.connect(WindowSizeWrapper)!;
  @Local topSafeHeight: number = this.storage.topSafeHeight;
  @Param translateX: number = 0; // 搜索框偏移度
  @Local searchText: string = ''; //搜索显示字段

  @Styles globalImage () {
  .width(22).height(22)
}
  build() {
    Stack(){
      Row(){
        Image($r('app.media.home_appBar_bg')).width(120).height(36).objectFit(ImageFit.Fill)
      }.alignItems(VerticalAlign.Center)
      .width('100%')
      .height(this.topSafeHeight + 44)
      .opacity(this.bgOpacity)
      .padding({top:this.topSafeHeight})

      Row() {
        Row(){
          Image($r('app.media.search')).width(16).height(16).margin({right:4}).objectFit(ImageFit.Fill);
          Text('搜宠物').fontColor('#999').fontSize(13)
        }
        .alignItems(VerticalAlign.Center).padding({left:12})
        .backgroundColor('#fff')
        .width(120)
        .height(28)
        .borderRadius(24)
        .translate({ x: this.translateX})
        .onClick(async ()=>{

        })

        Row(){
          Image($r('app.media.share')).globalImage().objectFit(ImageFit.Fill)
          Image($r('app.media.scan')).globalImage().objectFit(ImageFit.Fill)
        }
        .alignItems(VerticalAlign.Center)
        .padding({left:12})
        .width(80)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .padding({top:this.topSafeHeight,left:14,right:14})
      .height(this.topSafeHeight + 44)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .height(this.topSafeHeight + 44)
    .backgroundColor('#f8d147')
  }
}