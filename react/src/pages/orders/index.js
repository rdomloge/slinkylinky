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
        ***REMOVED***
    ***REMOVED***
        return true
***REMOVED***

    function sortOrders(a,b) {
        const aComplete = isOrderComplete(a)
        const bComplete = isOrderComplete(b)
        if(aComplete && !bComplete) {
            return 1
    ***REMOVED***
        else if(bComplete && !aComplete) {
            return -1
    ***REMOVED***
        else return b.externalId - a.externalId
***REMOVED***

    useEffect( () => {
        fetch("/.rest/orders?projection=lightOrder")
            .then((res) => res.json())
            .then((result)=> {
                const sorted = result._embedded.orders.sort((a,b) => sortOrders(a,b))
                setOrders(sorted)
        ***REMOVED***)
            .catch((error)=>{
                setError("Can't fetch orders. Is the Order service running?")
        ***REMOVED***)
***REMOVED***,[]);

    return (
        <Layout>
            <PageTitle title="Orders" />
            { !error && orders ?
                <div className="">
                    {orders.map( (order,index) => {
                        return <OrderCard order={order} key={index}/>
                ***REMOVED***)}
                </div>
            :
                <Loading error={error}/>
        ***REMOVED***
        </Layout>
    )
}