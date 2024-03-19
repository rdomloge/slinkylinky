import { t, Selector } from "testcafe";

class supplierListModel {
    constructor() {
        this.pageTitle = Selector('div').find('.pageTitle')
        
        this.newButton = Selector('button')
            .with({visibilityCheck: true})
            .withExactText('New');

        this.supplierMenuItem = Selector('#__next > div > div:nth-child(1) > div > div:nth-child(3) > a')
    }
}


export default new supplierListModel();
