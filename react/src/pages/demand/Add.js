import React, {useState, useEffect} from 'react'
import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import AddOrEditDemand from '@/components/AddOrEditDemand';

export default function NewDemand() {

    const [demand, setDemand] = useState({})

    function updateNudge(newDemand) {
        setDemand({...newDemand})
***REMOVED***

    return( 
        <Layout>
            <PageTitle title="New demand"/>
            <AddOrEditDemand demand={demand} updateNudge={updateNudge}/> 
        </Layout>
    );
}