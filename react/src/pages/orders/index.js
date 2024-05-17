import Loading from "@/components/Loading";
import OrderCard from "@/components/OrderCard";
import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import { useEffect, useState } from "react";

export default function ListOrders() {

    const [orders, setOrders] = useState()
    const [error, setError] = useState()

    function isOrderComplete(order) {
        for(let lineItem of order.lineItems) {
            if ( ! lineItem.proposalComplete) {
                return false
            }
        }
        return true
    }

    function sortOrders(a,b) {
        const aComplete = isOrderComplete(a)
        const bComplete = isOrderComplete(b)
        if(aComplete && !bComplete) {
            return 1
        }
        else if(bComplete && !aComplete) {
            return -1
        }
        else return b.externalId - a.externalId
    }

    function archiveHandler(order) {
        const index = orders.indexOf(order)
        if(index > -1) {
            const newOrders = [...orders]
            newOrders.splice(index,1)
            setOrders(newOrders)
        }
    }

    useEffect( () => {
        fetch("/.rest/orders/search/findOrdersByArchivedEquals?archived=false&projection=lightOrder")
            .then((res) => res.json())
            .then((result)=> {
                const sorted = result.sort((a,b) => sortOrders(a,b))
                setOrders(sorted)
            })
            .catch((error)=>{
                setError("Can't fetch orders. Is the Order service running?")
            })
    },[]);

    return (
        <Layout>
            <PageTitle title="Orders" id="order-list-title-id" />
            { !error && orders ?
                <div className="">
                    {orders.map( (order,index) => {
                        return <OrderCard order={order} key={index} archiveHandler={archiveHandler}/>
                    })}
                </div>
            :
                <Loading error={error}/>
            }
        </Layout>
    )
}