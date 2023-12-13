'use client'

import CategorySelector from '@/components/CategorySelector'
import Image from 'next/image'
import Icon from '@/components/shipping.png'
import TextInput from '@/components/atoms/TextInput'
import NumberInput from '@/components/atoms/NumberInput'
import React, {useState} from 'react';
import DisableToggle from './atoms/DisableToggle'

export default function AddOrEditSupplier({supplier}) {

    const [errorMsg, setErrorMsg] = useState()

    function handleError(message) {
        setErrorMsg("Create failed: "+message)
***REMOVED***
    
    function submitHandler() {
        console.log("Updating supplier: "+JSON.stringify(supplier))
        const supplierUrl = "/.rest/suppliers"
        const patchData = {...supplier}
        delete patchData._links
        if(supplier.categories) {
            patchData.categories = supplier.categories.map((c)=>c.value ? c.value : c._links.self.href)
    ***REMOVED***

        if(supplier.id) {
            fetch(supplierUrl+"/"+supplier.id, {
                method: 'PATCH',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(patchData)
        ***REMOVED***)
            .then( (resp) => {
                if(resp.ok) {
                    location.href = "/supplier/"+supplier.id;
            ***REMOVED***
                else {
                    handleError(resp.status === 409 ? "Website already exists" : "Unknown error: "+resp.status)
            ***REMOVED***
        ***REMOVED***)
            .catch(err => { handleError("Oops") ***REMOVED***
    ***REMOVED***
        else {
            fetch(supplierUrl, {
                method: 'POST',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(patchData)
        ***REMOVED***)
            .then( (resp) => {
                if(resp.ok) {
                    const locationUrl = resp.headers.get('Location')
                    location.href = "/supplier/"+locationUrl.substring(locationUrl.lastIndexOf('/')+1);
            ***REMOVED***
                else {
                    handleError(resp.status === 409 ? "Website already exists" : "Unknown error: "+resp.status)
            ***REMOVED***
        ***REMOVED***)
            .catch(err => { 
                handleError("Oops") ***REMOVED***
    ***REMOVED***
***REMOVED***

    return (
        <>
            {supplier ?
            <div className="list-card card">
                <p className='text-red-600'>{errorMsg}</p>
                <div className='float-right p-1 '>
                    <button id="createnew" onClick={submitHandler} 
                        className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded block mb-4">
                        Submit
                    </button>
                    <DisableToggle changeHandler={(e) => supplier.disabled = e} initialValue={supplier.disabled}/>
                </div>
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
                        initialValue={supplier.categories}/>
                </div>
            </div>
            : <p>Loading supplier</p>}
        </>
        
    )
}