import OrderLineItem from "./OrderLineItem"
import { NiceDateTime } from "./atoms/DateTime"

export default function OrderCard({order}) {


    function isOrderComplete() {
        for(let lineItem of order.lineItems) {
            if ( ! lineItem.proposalComplete) {
                return false
            }
        }
        return true
    }


    return (
        <div key={order.id} className="card m-4">
            <h2 className={"text-6xl font-bold "+(isOrderComplete() ? "text-green-500" : "")}>Order {order.externalId}</h2>
            <span className="align-middle">Created</span> <NiceDateTime isostring={order.dateCreated.substring(0, order.dateCreated.lastIndexOf('.'))} />
            {order.lineItems.map( (lineItem) => {
                return (
                    <div key={lineItem.id}>
                        <OrderLineItem lineItem={lineItem}/>
                    </div>
                )
            })}
        </div>
    )
}