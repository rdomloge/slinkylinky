import { Selector } from "testcafe";

class menu {
    constructor() {
        this.supplierItem = Selector('#__next > div > div:nth-child(1) > div > div:nth-child(3) > a');
        
    }
}

export default new menu();