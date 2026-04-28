import { CommonConstants } from '../../../constants';
import { ProductFindResponse } from '../../../api';
import { CustomLoadMore } from '../../../components';
import { CommonLoadMoreStatus } from '../../../interface/common';
import { ComponentContent } from '@kit.ArkUI';

@Builder
function buildLoadMore(params: CommonLoadMoreStatus) {
  Column() {
    CustomLoadMore({loadMore: params})
  }
}

@ComponentV2
export struct WaterfallFlow {
  @Param productList: ProductFindResponse[] = [];
  @Param onProductClick: (product: ProductFindResponse) => void = () => {};
  @Param @Require loadMore:CommonLoadMoreStatus;
  @Param @Require onLoadMore: () => void;
  @Local scroller: Scroller = new Scroller();
  context: UIContext = this.getUIContext();

  @Monitor("loadMore")
  loadMoreChange() {
    this.footerContent.update(this.loadMore)
  }
  // 构建商品卡片
  @Builder
  ProductCard(product: ProductFindResponse) {
    FlowItem() {
      Column() {
        // 商品图片
        Stack({ alignContent: Alignment.TopEnd }) {
            Image(product.mainImage)
              .width('100%')
              .height(160)
              .objectFit(ImageFit.Cover)


          // 优选标签
          if (product.isExcellence === 1) {
            Text('优选')
              .fontSize(10)
              .fontColor(Color.White)
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .backgroundColor('#FF6B6B')
              .borderRadius(4)
              .margin(8)
          }
        }

        // 商品信息
        Column() {
          // 标题
          Text(product.title || product.name)
            .fontSize(13)
            .fontWeight(500)
            .fontColor('#333333')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .lineHeight(20)
            .margin({ bottom: 8 })

          // 价格信息
          Row() {
            // 当前售价
            Text(`¥${product.price}`)
              .fontSize(14)
              .fontColor('#FF6B6B')
              .fontWeight(700)

            // 原价（如果有且大于现价）
            if (product.originPrice && product.originPrice > product.price) {
              Text(`¥${product.originPrice}`)
                .fontSize(12)
                .fontColor('#999999')
                .margin({ left: 8 })
                .decoration({ type: TextDecorationType.LineThrough })
            }
          }
          .margin({ bottom: 8 })

          // 底部信息
          Row() {
            // 包邮标签
            if (product.isShipFree === 1) {
              Text('包邮')
                .fontSize(10)
                .fontColor('#4ECDC4')
                .padding({ left: 4, right: 4, top: 2, bottom: 2 })
                .border({ width: 1, color: '#4ECDC4', radius: 2 })
                .margin({ right: 8 })
            }

            // 宠物名称
            Text(product.name)
              .fontSize(12)
              .fontColor('#666666')
              .layoutWeight(1)
          }
        }
        .width('100%')
        .padding(12)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius(12)
      .clip(true)
      .shadow({
        radius: 4,
        offsetX: 0,
        offsetY: 2,
        color: 'rgba(0, 0, 0, 0.05)'
      })
    }
    .width('100%')
    .onClick(() => {
      this.onProductClick(product);
    })
  }



  footerContent: ComponentContent<CommonLoadMoreStatus> = new ComponentContent<CommonLoadMoreStatus>(
    this.context,
    wrapBuilder<[CommonLoadMoreStatus]>(buildLoadMore),
    this.loadMore
  );

  build() {
    WaterFlow({ scroller: this.scroller,footerContent: this.footerContent}) {
      ForEach(this.productList, (product: ProductFindResponse) => {
        this.ProductCard(product)
      }, (product: ProductFindResponse) => product.id.toString())
    }
    .width(CommonConstants.FULL_WIDTH)
    .layoutWeight(1)
    .layoutDirection(FlexDirection.Column)
    .columnsTemplate('1fr 1fr')  // 两列
    .columnsGap(12)  // 列间距
    .rowsGap(12)     // 行间距+
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST
    })
    .onReachEnd(() => {
        this.onLoadMore();
    })
  }
}
