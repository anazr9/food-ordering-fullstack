import { Menu } from "./menu";
import Pageable from "./pageable";
import Restaurant, { Location } from "./restaurant";

export default interface IRestaurantRepository {
  findAll(page: number, pageSize: number): Promise<Pageable<Restaurant>>;
  findOne(id: string): Promise<Restaurant>;
  findByLocation(
    location: Location,
    page: number,
    pageSize: number
  ): Promise<Pageable<Restaurant>>;
  search(
    page: number,
    pageSize: number,
    query: string
  ): Promise<Pageable<Restaurant>>;
  getMenus(restaurantId: string): Promise<Menu[]>;
}
