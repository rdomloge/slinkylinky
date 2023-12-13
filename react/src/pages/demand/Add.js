import React, {useState, useEffect} from 'react'
import CategorySelector from "@/components/CategorySelector";
import Layout from "@/components/layout";
import PageTitle from "@/components/pagetitle";
import { useSession } from "next-auth/react";
import TextInput from '@/components/TextInput';
import NumberInput from '@/components/NumberInput';
import AddOrEditDemand from '@/components/AddOrEditDemand';

export default function NewDemand() {

    return( 
        <Layout>
            <PageTitle title="New demand"/>
            <AddOrEditDemand demand={({})}/> 
        </Layout>
    );
}