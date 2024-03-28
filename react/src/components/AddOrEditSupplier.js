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
import { url_domain, validDomain } from "./Util";
import { WarningMessage } from "./atoms/Messages";

export default function AddOrEditSupplier({supplier}) {

    if( ! supplier) throw new Error("Supplier cannot be null. If you are loading it, wrap this component in a null check before using it")

    const { data: session } = useSession();
    const [errorMsg, setErrorMsg] = useState()
    const [showStatsModal, setShowStatsModal] = useState(false)
    const [showBlacklistModal, setShowBlacklistModal] = useState(false)

    const [supplierName, setSupplierName] = useState(supplier.name)
    const [supplierDa, setSupplierDa] = useState(supplier.da)	
    const [supplierSpamScore, setSupplierSpamScore] = useState()
    const [supplierWebsite, setSupplierWebsite] = useState(supplier.website)
    const [supplierSource, setSupplierSource] = useState(supplier.source)
    const [supplierEmail, setSupplierEmail] = useState(supplier.email)
    const [supplierCurrency, setSupplierCurrency] = useState(supplier.weWriteFeeCurrency)
    const [supplierFee, setSupplierFee] = useState(supplier.weWriteFee)

    const [supplierAlreadyExists, setSupplierAlreadyExists] = useState(false)
    const [supplierIsBlackListed, setSupplierIsBlackListed] = useState(false)
    const [showStatsButton, setShowStatsButton] = useState(false)
    const [dataPoints, setDataPoints] = useState([])


    function handleError(message) {
        setErrorMsg("Create failed: "+message)
    }

    async function supplierWebsiteChangeHandler(e) {
        setSupplierWebsite(e)
        if(validDomain(e)) {
            let existsAlready = await checkIfSupplierExists(e)
            let blacklisted = await checkIfSupplierIsBlacklisted(e)
            setShowStatsButton(!existsAlready && !blacklisted)
        }
        else {
            setShowStatsButton(false)
        }
    }

    function checkIfSupplierIsBlacklisted(website) {
        const url = "/.rest/blackListedSupplierSupport/isBlackListed?website="+url_domain(website)
        return fetch(url, { method: 'GET', headers: {'user': session.user.email}})
                .then( (resp) => {
                    if(resp.ok) {
                        return resp.json().then( (data) => {
                            console.log("Blacklisted: "+data)
                            setSupplierIsBlackListed(data)
                            return data
                        })
                    }
                    else {
                        console.log("Error determing whether blacklisted")
                        return false
                    }
                })
                .catch(err => { 
                    return false 
                });
    }

    function checkIfSupplierExists(website) {
        const url = "/.rest/supplierSupport/exists?supplierWebsite="+website
        return fetch(url, {method: 'GET', headers: {'user': session.user.email}})
                .then( (resp) => {
                    if(resp.ok) {
                        return resp.json().then( (data) => {
                            setSupplierAlreadyExists(data)
                            console.log("Supplier "+(data?"exists":"does not exist"))
                            return data
                        })
                    }
                    else {
                        return false
                    }
                })
                .catch(err => { 
                    return false
                });
    }

    function lookupDa(domain) {
        const url = "/.rest/mozsupport/checkdomain?domain="+domain
        fetch(url, {method: 'GET', headers: {'user': session.user.email}})
        .then( (resp) => {
            if(resp.ok) {
                resp.json().then( (data) => {
                    supplier.da = data.domain_authority
                    setSupplierDa(data.domain_authority)
                    setSupplierSpamScore(data.spam_score)
                })
            }
            else {
                handleError("Unknown error: "+resp.status)
            }
        })
        .catch(err => { handleError("Oops") });
    }

    function displaySemData() {
        supplier.domain = url_domain(supplierWebsite)
        lookupDa(supplier.domain)
        setShowStatsModal(true)
    }

    function doBlackList() {
        console.log("Blacklisting "+supplierWebsite)
        setShowBlacklistModal(false)
        setShowStatsModal(false)

        const url = "/.rest/blackListedSupplierSupport/addBlackListed?website="+url_domain(supplierWebsite)
            + "&da="+supplierDa
            + "&spamRating="+supplierSpamScore

        fetch(url, {method: 'POST', headers: {'user': session.user.email}, body: JSON.stringify(dataPoints)})

        setSupplierIsBlackListed(true)
    }

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
        }
        delete patchData._links
        
        fixForPosting(patchData)

        if(supplier.id) {

            patchData.updatedBy = session.user.email
            
            fetch(supplierUrl+"/"+supplier.id, {
                method: 'PATCH',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(patchData)
            })
            .then( (resp) => {
                if(resp.ok) {
                    // location.href = "/supplier/"+supplier.id;
                    location.href = "/supplier";
                }
                else {
                    handleError(resp.status === 409 ? "Website already exists" : "Unknown error: "+resp.statusText)
                }
            })
            .catch(err => { handleError("Oops") });
        }
        else {

            patchData.createdBy = session.user.email
            if( ! patchData.weWriteFeeCurrency) patchData.weWriteFeeCurrency = "£"

            fetch(supplierUrl, {
                method: 'POST',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(patchData)
            })
            .then( (resp) => {
                if(resp.ok) {
                    // const locationUrl = resp.headers.get('Location')
                    // location.href = "/supplier/"+locationUrl.substring(locationUrl.lastIndexOf('/')+1);
                    location.href = "/supplier";
                }
                else {
                    handleError(resp.status === 409 ? "Website already exists" : "Unknown error: "+resp.statusText)
                }
            })
            .catch(err => { 
                handleError("Oops") });
        }
    }

    function submitEnabled() {
        return supplierName.length > 2 
            && ! supplierAlreadyExists
            && validDomain(supplierWebsite)
    }

    return (
        <>
            {supplier != null ?
                <div className="list-card card">
                    <p className='text-red-600'>{errorMsg}</p>
                    <div className='float-right p-1 '>
                        <StyledButton label="Submit" type="primary" submitHandler={submitHandler} extraClass="block" enabled={submitEnabled()}/>
                        
                        <DisableToggle changeHandler={(e) => supplier.disabled = e} initialValue={supplier.disabled}/>
                    </div>
                    <Image src={Icon} width={32} height={32} alt="Shipping icon"/>


                    <div className='w-1/4 inline-block pr-8'> 
                        <TextInput binding={supplierName} label={"Name (min. 3)"} changeHandler={(e)=>setSupplierName(e)}/> 
                    </div>
                    <div className='w-28 inline-block pr-8'>
                        <NumberInput label={"DA"} changeHandler={(e) => setSupplierDa(e)} binding={supplierDa}/>
                    </div>
                    <div className='w-1/4 inline-block pr-8'>
                        <TextInput binding={supplierWebsite} label={"Website"} changeHandler={(e)=>supplierWebsiteChangeHandler(e)} />
                        {supplierAlreadyExists ? 
                            <p id="supplierExistsMessage" className="mt-2 text-sm text-red-600 dark:text-red-500 float-left">
                                <span className="font-medium">Error! </span> 
                                Supplier exists.
                            </p> 
                        : <p className="mt-2 text-sm text-red-600 dark:text-red-500 float-left">  &nbsp; </p> }
                        {supplierIsBlackListed ? 
                            <p id="blacklistedSupplierMessage" className="mt-2 text-sm text-red-600 dark:text-red-500 float-left">
                                <span className="font-medium">Error! </span> 
                                Supplier is blacklisted.
                            </p> 
                        : <p className="mt-2 text-sm text-red-600 dark:text-red-500 float-left">  &nbsp; </p> }
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

                    {supplier.id == null && showStatsButton ?
                        <div className="inline-block float-right">
                            <label className="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" htmlFor="srButton">
                                Fetch DA and load SEM rush traffic (cost attached)
                            </label>
                            <StyledButton id="srButton" label="Load" type="risky"
                                submitHandler={()=>displaySemData()}  />
                        </div>
                    :
                        null
                    }

                    <div className='w-1/2 mt-8'>
                        <CategorySelector label="Categories"
                            changeHandler={(e)=> supplier.categories = e}
                            initialValue={supplier.categories}/>
                    </div>
                    {showStatsModal ?
                        <Modal title={"SEM rush traffic // "+supplier.domain} dismissHandler={()=>setShowStatsModal(false)} width={"w-2/3"} id="stats-modal">
                            <StyledButton label="Blacklist" type="risky" submitHandler={()=>setShowBlacklistModal(true)} extraClass=" mt-0 float-right"/>
                            <span className="inline-block mr-6">Domain authority: 
                                <span className="text-2xl" > {supplierDa}</span>
                            </span>
                            <span>Spam score: 
                                <span className="text-2xl" > {supplierSpamScore}</span>
                            </span>
                            <SupplierSemRushTraffic supplier={supplier} adhoc={true} dataListener={(data) => setDataPoints(data)}/>
                        </Modal>
                    : 
                        null
                    }

                    {showBlacklistModal ?
                        <Modal title={"Blacklist supplier"} dismissHandler={()=>setShowBlacklistModal(false)} width={"w-1/2"} id="blacklist-modal">
                            <p className="p-2 text-2xl">{"Are you sure you want to blacklist "}<span className="font-bold">{supplierWebsite}</span>{"?"}</p>
                            <WarningMessage message={"This is permanent action and future users will be prevented from creating Suppliers with this domain"}/>
                            <StyledButton  label="Blacklist" type="risky" submitHandler={()=>doBlackList()} extraClass=" mt-4 float-right"/>
                        </Modal>
                    :
                        null
                    }
                </div>
            : 
                <p>Loading supplier</p>
            }
        </>
        
    )
}