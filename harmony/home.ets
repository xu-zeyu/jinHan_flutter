import { CustomLoadMore, CustomRefresh } from "../../components"
import { CommonConstants } from "../../constants";
import { CustomRefreshImp } from "../../imp/Refresh";
import { commonStore, WindowSizeWrapper } from "../../utils";
import { AppStorageV2 } from "@kit.ArkUI";
import SearchBar from "./component/SearchBar";
import { IBannerType, getBannerList, VarietyType, getHotVarietyList, ProductFindResponse, getProductList } from "../../api";
import { BannerSwiper } from "./component/BannerSwiper";
import { HotVarietyGrid } from "./component/HotVarietyGrid";
import { WaterfallFlow } from "./component/WaterfallFlow";
import { CommonLoadMoreStatus, IPagePaging } from "../../interface/common";
import { RouterConfig } from "../../utils/routerConfig";
import { router } from "@kit.ArkUI";
import { StoreKey, StoreLoginType } from "../../interface/store";

interface IProductsParams extends  IPagePaging {}
@ComponentV2
export struct Home {
  @Local refreshConstructor: CustomRefreshImp = new CustomRefreshImp(true);
  @Local storage: WindowSizeWrapper = AppStorageV2.connect(WindowSizeWrapper)!;
  @Local topSafeHeight: number = this.storage.topSafeHeight;
  scrollY: number = 0; // 滚定距离
  @Local bgOpacity: number = 0 //导航栏背景透明度
  @Local translateX: number = 0 //导航栏背景
  @Local bannerList: IBannerType[] = [];
  @Local varietyList: VarietyType[] = [];
  @Local productList: ProductFindResponse[] = [];
  @Local currentPage: number = 1;
  @Local pageSize: number = 10;
  @Local loadMore: CommonLoadMoreStatus = 'load';

  @Local productsParams:IProductsParams = {
    page: 1,
    size: 10
  }

  // 加载 Banner 数据
  async loadBannerData() {
    try {
      const response = await getBannerList({
        page: 1,
        size: 10
      });
      if (response.code === '200' && response.data) {
        this.bannerList = response.data.records || [];
      }
    } catch (error) {
      console.error('加载 Banner 失败:', JSON.stringify(error));
    }
  }

  // 加载热门品种数据
  async loadVarietyData() {
    try {
      const response = await getHotVarietyList();
      if (response.code === '200' && response.data) {
        this.varietyList = response.data || [];
      }
    } catch (error) {
      console.error('加载热门品种失败:', JSON.stringify(error));
    }
  }

  // 加载商品列表数据
  async loadProductData() {
    this.productsParams.page = 1
    try {
      const response = await getProductList({
        page: this.productsParams.page,
        size: this.productsParams.size
      });

      if (response.code === '200' && response.data && response.data.records.length > 0) {
        this.productsParams.page = response.data.current + 1
        this.productList = response.data.records || [];
      }else  {
        this.productList = []
      }
      this.loadMore =  this.productList.length >= response.data.total  ? 'done' : 'load'
    } catch (error) {
      this.loadMore = 'load'
    } finally {
    }
  }

  // 加载更多商品
  async loadMoreProducts() {
    if (this.loadMore != 'load') {
     return;
    }

    this.loadMore = 'loading'
    setTimeout(async () => {
      try {
        const response = await getProductList({
          page: this.productsParams.page,
          size: this.productsParams.size
        });
        if (response.code === '200' && response.data && response.data.records.length > 0) {
          this.productsParams.page = response.data.current + 1
          response.data.records.map((item) => {
            this.productList.push(item)
          });
        }
        this.loadMore = this.productList.length >= response.data.total  ? 'done' : 'load'
      }catch {
        this.loadMore = 'load'
      }
    },1000)
  }

  handleScroll(x: number, y: number) {
    // 更新并修正 scrollY 的值
    const scrollY = this.scrollY + y;
    this.scrollY = scrollY < 0 ? 0 : scrollY;
    this.calcColor();
  }

  calcColor() {
    if (this.scrollY < 140 && this.scrollY >= 0) {
      this.translateX = this.scrollY
    } else if (this.scrollY > 140) {
      this.translateX = 140
    } else {
      this.translateX = 0
    }

    let alpha = this.scrollY / 100;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    this.bgOpacity = alpha
  }

  aboutToAppear(): void {
    // 加载 Banner 数据
    this.loadBannerData();
    // 加载热门品种数据
    this.loadVarietyData();
    // 加载商品列表数据
    this.loadProductData();
  }

  build() {
    Column() {
        // 头部输入框
        SearchBar({ bgOpacity: this.bgOpacity, translateX: this.translateX });
        CustomRefresh({
        refreshConstructor: this.refreshConstructor,
        onRefresh: async () => {
          // 下拉刷新时重新加载 Banner、热门品种和商品列表
          await this.loadBannerData();
          await this.loadVarietyData();
          this.currentPage = 1
          await this.loadProductData();
        },
      }) {
          Scroll() {
            Column() {
              Column() {
              }
              .width(CommonConstants.FULL_WIDTH)
              .height(150)
              .backgroundColor(CommonConstants.primaryColor)
              .borderRadius({
                bottomLeft: 18,
                bottomRight: 18
              })

              Column() {
                // Banner 轮播图
               Column(){
                 BannerSwiper({
                   bannerList: this.bannerList,
                   onBannerClick: (banner: IBannerType) => {
                     // Banner 点击事件
                     console.log('点击 Banner:', JSON.stringify(banner));
                   }
                 })
               }.width(CommonConstants.FULL_WIDTH).height(150 - 14).padding({top: 14})
                // 热门宠物网格
                HotVarietyGrid({
                  varietyList: this.varietyList,
                  onVarietyClick: (variety: VarietyType) => {
                    // 品种点击事件
                    console.log('点击品种:', JSON.stringify(variety));
                  }
                }).margin({top: 24})

                // 商品瀑布流
                Column() {
                  // 瀑布流组件
                  WaterfallFlow({
                    productList: this.productList,
                    onProductClick: async (product: ProductFindResponse) => {
                      // 检查登录状态
                      // 配置项 url 请求地址, methods 请求方法, 请求头headers 请求参数 等等
                      const token = await commonStore<StoreLoginType>(StoreKey.loginStore).getStoreInfo()
                      if (!token.accessToken) {
                        // 未登录，跳转到登录页
                        router.pushUrl({
                          url: RouterConfig.LOGIN_URL.path
                        })
                        return
                      }
                      // 已登录，跳转到商品详情页
                      router.pushUrl({
                        url: RouterConfig.PRODUCT_DETAIL_URL.path,
                        params: { productId: product.id }
                      })
                    },
                    loadMore: this.loadMore,
                    onLoadMore: () => {
                      // 加载更多
                      this.loadMoreProducts();
                    }
                  })
                }
                .width(CommonConstants.FULL_WIDTH)
                .margin({ top: 14 })
              }.width(CommonConstants.FULL_WIDTH).margin({ top: -150 }).padding({left: 14, right: 14})

            }.width(CommonConstants.FULL_WIDTH).height("auto")
          }
          .width(CommonConstants.FULL_WIDTH)
          .layoutWeight(1)
          .align(Alignment.TopStart)
          .scrollBar(BarState.Off)
          .onWillScroll((xOffset: number, yOffset: number, _scrollState: ScrollState) => {
            this.handleScroll(xOffset, yOffset)
          })
          .backgroundColor(CommonConstants.cardBgColor)
      }
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .backgroundColor(CommonConstants.primaryColor)
  }
}