import { IBannerType } from '../../../api'

@ComponentV2
export struct BannerSwiper {
  @Param bannerList: IBannerType[] = []
  private swiperController: SwiperController = new SwiperController()
  
  @Event onBannerClick: (banner: IBannerType) => void = () => {}

  @Builder
  bannerItemBuilder(banner: IBannerType) {
    Stack({ alignContent: Alignment.BottomStart }) {
      Image(banner.url)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Fill)
        .borderRadius(12)
    }
    .width('100%')
    .height('100%')
    .onClick(() => {
      this.onBannerClick(banner)
    })
  }

  build() {
    if (this.bannerList.length > 0){
      Swiper(this.swiperController) {
        ForEach(this.bannerList, (banner: IBannerType) => {
          this.bannerItemBuilder(banner)
        }, (banner: IBannerType) => banner.id.toString())
      }
      .index(0)
      .autoPlay(true)
      .loop(true)
      .interval(3000)
      .indicatorInteractive(true)
      .duration(300)
      .itemSpace(0)
      .indicator(
        new DotIndicator()
          .itemWidth(6)
          .itemHeight(6)
          .selectedItemWidth(8)
          .selectedItemHeight(8)
          .color('rgba(255, 255, 255, 0.5)')
          .selectedColor($r('sys.color.comp_background_list_card'))
      )
      .borderRadius(14)
      .width('100%')
      .height(124)
    }else {
      Column(){
      }
      .width('100%')
      .height(124)
      .backgroundColor('rgba(255,255,255,0.6)')
      .borderRadius(14)
    }

  }
}
