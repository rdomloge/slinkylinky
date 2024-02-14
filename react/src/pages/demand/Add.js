import React, {useState, useEffect} from 'react'
import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import AddOrEditDemand from '@/components/AddOrEditDemand';

export default function NewDemand() {

    return( 
        <Layout>
            <PageTitle title="New demand"/>
            <AddOrEditDemand demand={ {name: "", anchorText: "", url: "", daNeeded: 0, requested: null} } /> 
        </Layout>
    );
}