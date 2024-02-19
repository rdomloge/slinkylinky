'use client'

import { useSession } from "next-auth/react";

import CategorySelector from '@/components/CategorySelector'
import Image from 'next/image'
import Icon from '@/components/shipping.png'
import TextInput from '@/components/atoms/TextInput'
import NumberInput from '@/components/atoms/NumberInput'
import React, {useState} from 'react';
import DisableToggle from './atoms/DisableToggle'
import { fixForPosting } from "./CategoryUtil";
import { StyledButton } from "./atoms/Button";
import Modal from "./atoms/Modal";
import SupplierSemRushTraffic from "./SupplierStats";

export default function AddOrEditSupplier({supplier}) {

    if( ! supplier) throw new Error("Supplier cannot be null. If you are loading it, wrap this component in a null check before using it")

    const { data: session } = useSession();
    const [errorMsg, setErrorMsg] = useState()
    const [showModal, setShowModal] = useState(false)

    const [supplierName, setSupplierName] = useState(supplier.name)
    const [supplierDa, setSupplierDa] = useState(supplier.da)	
    const [supplierSpamScore, setSupplierSpamScore] = useState()
    const [supplierWebsite, setSupplierWebsite] = useState(supplier.website)
    const [supplierSource, setSupplierSource] = useState(supplier.source)
    const [supplierEmail, setSupplierEmail] = useState(supplier.email)
    const [supplierCurrency, setSupplierCurrency] = useState(supplier.weWriteFeeCurrency)
    const [supplierFee, setSupplierFee] = useState(supplier.weWriteFee)


    function handleError(message) {
        setErrorMsg("Create failed: "+message)
***REMOVED***

    function addProtocol(url) {
        if (!/^(?:f|ht)tps?\:\/\//i.test(url)) {
            url = "https://" + url;
    ***REMOVED***
        return url;
***REMOVED***

    function url_domain(data) {
        let domain =  new URL(addProtocol(data))
        let hostname = domain.hostname
        return hostname.replace('www.','');
***REMOVED***

    function lookupDa(domain) {
        const url = "/.rest/mozsupport/checkdomain?domain="+domain
        fetch(url, {method: 'GET', headers: {'user': session.user.email}})
        .then( (resp) => {
            if(resp.ok) {
                resp.json().then( (data) => {
                    supplier.da = data.domain_authority
                    setSupplierDa(data.domain_authority)
                    setSupplierSpamScore(data.spam_score)
            ***REMOVED***)
        ***REMOVED***
            else {
                handleError("Unknown error: "+resp.status)
        ***REMOVED***
    ***REMOVED***)
        .catch(err => { handleError("Oops") ***REMOVED***
***REMOVED***

    function displaySemData() {
        supplier.domain = url_domain(supplierWebsite)
        lookupDa(supplier.domain)
        setShowModal(true)
***REMOVED***

    function domainValidation(url) {
         const urlRegex = /^(((http|https):\/\/|)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?)$/;
         if (urlRegex.test(url)) {
              return true;
      ***REMOVED*** else {
              return false;
      ***REMOVED***
***REMOVED***;

    function submitHandler() {
        console.log("Updating supplier: "+JSON.stringify(supplier))
        const supplierUrl = "/.rest/suppliers"
        const patchData = {
            name: supplierName,
            da: supplierDa,
            website: supplierWebsite,
            source: supplierSource,
            email: supplierEmail,
            weWriteFee: supplierFee,
            weWriteFeeCurrency: supplierCurrency,
            disabled: supplier.disabled,
            categories: supplier.categories
    ***REMOVED***
        delete patchData._links
        
        fixForPosting(patchData)

        if(supplier.id) {

            patchData.updatedBy = session.user.email
            
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
                    handleError(resp.status === 409 ? "Website already exists" : "Unknown error: "+resp.statusText)
            ***REMOVED***
        ***REMOVED***)
            .catch(err => { handleError("Oops") ***REMOVED***
    ***REMOVED***
        else {

            patchData.createdBy = session.user.email
            if( ! patchData.weWriteFeeCurrency) patchData.weWriteFeeCurrency = "£"

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
                    handleError(resp.status === 409 ? "Website already exists" : "Unknown error: "+resp.statusText)
            ***REMOVED***
        ***REMOVED***)
            .catch(err => { 
                handleError("Oops") ***REMOVED***
    ***REMOVED***
***REMOVED***

    return (
        <>
            {supplier != null ?
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


                    <div className='w-1/4 inline-block pr-8'> 
                        <TextInput binding={supplierName} label={"Name"} changeHandler={(e)=>setSupplierName(e)}/> 
                    </div>
                    <div className='w-28 inline-block pr-8'>
                        <NumberInput label={"DA"} changeHandler={(e) => setSupplierDa(e)} binding={supplierDa}/>
                    </div>
                    <div className='w-1/4 inline-block pr-8'>
                        <TextInput binding={supplierWebsite} label={"Website"} changeHandler={(e)=>setSupplierWebsite(e)}/> 
                    </div>
                    <div className='w-1/4 inline-block pr-8'>
                        <TextInput binding={supplierSource} label={"Source"} changeHandler={(e)=>setSupplierSource(e)}/> 
                    </div>


                    <div className='w-1/3 inline-block pr-8'>
                        <TextInput binding={supplierEmail} label={"Email"} changeHandler={(e)=>setSupplierEmail(e)}/> 
                    </div>
                    
                    
                    <div className='w-20 inline-block pr-8 mt-8'>
                        <TextInput binding={supplierCurrency} label="Currency" changeHandler={(e)=>setSupplierCurrency(e)} maxLen={1}/>
                    </div>
                    <div className='w-28 inline-block pr-8'>
                        <NumberInput binding={supplierFee} label={"Fee"} changeHandler={(e)=>setSupplierFee(e)}/>
                    </div>

                    {supplier.id == null && supplierWebsite && domainValidation(supplierWebsite) ?
                        <div className="inline-block">
                            <label className="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" htmlFor="srButton">
                                Fetch DA and load SEM rush traffic (cost attached)
                            </label>
                            <StyledButton id="srButton" label="Load" type="risky"
                                submitHandler={()=>displaySemData()}  />
                        </div>
                    :
                        null
                ***REMOVED***

                    <div className='w-1/2 mt-8'>
                        <CategorySelector label="Categories"
                            changeHandler={(e)=> supplier.categories = e}
                            initialValue={supplier.categories}/>
                    </div>
                    {showModal ?
                        <Modal title={"SEM rush traffic // "+supplier.domain} dismissHandler={()=>setShowModal(false)} width={"w-2/3"}>
                            <span className="inline-block mr-6">Domain authority: 
                                <span className="text-2xl" > {supplierDa}</span>
                            </span>
                            <span>Spam score: 
                                <span className="text-2xl" > {supplierSpamScore}</span>
                            </span>
                            <SupplierSemRushTraffic supplier={supplier} adhoc={true}/>
                        </Modal>
                    : 
                        null
                ***REMOVED***
                </div>
            : 
                <p>Loading supplier</p>
        ***REMOVED***
        </>
        
    )
}