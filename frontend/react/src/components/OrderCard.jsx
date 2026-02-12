import { useState } from "react";
import OrderLineItem from "./OrderLineItem"
import { StyledButton } from "./atoms/Button";
import { NiceDateTime } from "./atoms/DateTime"
import Modal from "./atoms/Modal";
import { useAuth } from "@/auth/AuthProvider";
import { fetchWithAuth } from "@/utils/fetchWithAuth";

export default function OrderCard({order, archiveHandler}) {

    const [showModal, setShowModal] = useState(false)
    const { user } = useAuth();


    function isOrderComplete() {
        for(let lineItem of order.lineItems) {
            if ( ! lineItem.proposalComplete) {
                return false
            }
        }
        return true
    }

    function calculateOrderWorth() {
        let worth = 0;
        for(let lineItem of order.lineItems) {
            worth += lineItem.price
        }
        return worth
    }

    function archiveOrder() {
        setShowModal(false)
        
        const orderUrl = "/.rest/orders/archiveorder?id="+order.id
        fetchWithAuth(orderUrl, {
            method: 'GET',
            headers: {
                'user': user.email
            }
        })
        .then( (res) => {
            if(res.ok) {
                archiveHandler(order)
            }
            else {
                console.error("Failed to archive order")
            }
        })
    }


    return (
        <div key={order.id} className="card m-4">
            <StyledButton label="Archive" type="risky" isText={true} extraClass="float-right" submitHandler={() => setShowModal(true)}/>
            <h2 className={"text-6xl font-bold "+(isOrderComplete() ? "text-green-500" : "")}>Order {order.externalId}</h2>
            <span className="text-red-500 block font-bold font-sm">Value: £{order.total}</span>
            <span className="align-middle">Created</span> <NiceDateTime isostring={order.dateCreated.substring(0, order.dateCreated.lastIndexOf('.'))} />
            <h3 className="font-bold text-2xl">{order.customerName} <span className="text-sm font-semibold">{order.shippingEmailAddress ? order.shippingEmailAddress : order.billingEmailAddress}</span></h3>
            {order.lineItems.map( (lineItem) => {
                return (
                    <div key={lineItem.id}>
                        <OrderLineItem lineItem={lineItem}/>
                    </div>
                )
            })}
            {showModal ?
                <Modal title="Archive order" dismissHandler={() => setShowModal(false)} width={"w-1/3"}>
                    <h1 className="font-bold text-2xl">Are you sure you want to archive this order?</h1>
                    <p>The order will remain in the database and the linked demand will not be affected, 
                        but it will no longer appear here <span className="italic">for anyone</span></p>
                    <div className="flex">
                        <div className="flex-0">
                            <StyledButton label="No" submitHandler={() => setShowModal(false)} type="secondary"/>
                        </div>
                        <div className="flex-0 ml-auto mr-0 cursor-default">
                            <StyledButton label="Yes" type="risky" submitHandler={() => archiveOrder()}/>
                        </div>
                    </div>
                </Modal>
            : 
                null
            }
        </div>
    )
}