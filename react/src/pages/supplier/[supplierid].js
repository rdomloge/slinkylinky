'use client'

import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'
import CategorySelector from '@/components/CategorySelector'
import Image from 'next/image'
import Icon from '@/components/shipping.png'
import Layout from '@/components/layout'
import TextInput from '@/components/TextInput'
import NumberInput from '@/components/NumberInput'

export default function AddEditSupplier() {
    const router = useRouter()
    const [supplier, setSupplier] = useState()

    useEffect(
        () => {
            if(router.isReady) {
                const supplierUrl = "http://localhost:8080/suppliers/"+router.query.supplierid+"?projection=fullSupplier";
                fetch(supplierUrl)
                    .then( (res) => res.json())
                    .then( (s) => {
                        setSupplier(s);
                ***REMOVED***);
        ***REMOVED***
    ***REMOVED***, [router.isReady, router.query.supplierid]);

    function extractUrl(category) {
        const url = category._links.self.href
        if(url.indexOf('{') > -1) return url.substring(0, url.indexOf('{'))
        else return url
***REMOVED***

    function submitHandler() {
        console.log("Updating supplier: "+JSON.stringify(supplier))
        const supplierUrl = "http://localhost:8080/suppliers/"+router.query.supplierid
        const patchData = {...supplier}
        delete patchData._links
        patchData.categories = supplier.categories.map((c)=>c.value ? c.value : c._links.self.href)
        fetch(supplierUrl, {
            method: 'PATCH',
            headers: {'Content-Type':'application/json'},
            body: JSON.stringify(patchData)
    ***REMOVED***)
        .then( (resp) => {
            if(resp.ok) {
                location.href = "/supplier/"+router.query.supplierid;
        ***REMOVED***
            else {
                console.log("Update failed");
        ***REMOVED***
    ***REMOVED***);
***REMOVED***

    return (
        
            <Layout>
            {supplier ?
                <>
                <div className="list-card card">
                    <button id="createnew" onClick={submitHandler} 
                        className="float-right bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded">
                        Submit
                    </button>
                    <Image src={Icon} width={32} height={32} alt="Shipping icon"/>
                    <div className='w-1/3 inline-block pr-8'> 
                        <TextInput initialValue={supplier.name} label={"Name"} changeHandler={(e)=>supplier.name = e}/> 
                    </div>
                    <div className='w-28 inline-block pr-8'>
                        <NumberInput initialValue={supplier.da} label={"DA"} changeHandler={(e)=>supplier.da = e}/>
                    </div>
                    <div className='w-1/3 inline-block pr-8'>
                        <TextInput initialValue={supplier.website} label={"Website"} changeHandler={(e)=>supplier.website = e}/> 
                    </div>
                    <div className='w-1/3 inline-block pr-8'>
                        <TextInput initialValue={supplier.email} label={"Email"} changeHandler={(e)=>supplier.email = e}/> 
                    </div>
                    <div className='w-28 inline-block pr-8'>
                        <NumberInput initialValue={supplier.weWriteFee} label={"Fee"} changeHandler={(e)=>supplier.weWriteFee = e}/>
                    </div>
                    <div className='w-28 inline-block pr-8 mt-8'>
                        <NumberInput initialValue={supplier.semRushAuthorityScore} label={"SEM rush authority"} 
                            changeHandler={(e)=>supplier.semRushAuthorityScore = e}/>
                    </div>
                    <div className='w-28 inline-block pr-8 mt-8'>
                        <NumberInput initialValue={supplier.semRushUkMonthlyTraffic} label={"SEM rush UK monthly"} 
                            changeHandler={(e)=>supplier.semRushUkMonthlyTraffic = e}/>
                    </div>
                    <div className='w-28 inline-block pr-8 mt-8'>
                        <NumberInput initialValue={supplier.semRushUkJan23Traffic} label={"SEM rush UK Jan '23"} 
                            changeHandler={(e)=>supplier.semRushUkJan23Traffic = e}/>
                    </div>
                    <div className='w-1/2 mt-8'>
                        <CategorySelector label="Categories"
                            changeHandler={(e)=> supplier.categories = e}
                            initialValue={supplier.categories.map(c=>({value:extractUrl(c), label: c.name}))}/>
                    </div>
                </div>
                </>
            : <p>Loading supplier</p>}
            </Layout>
        
    )
}