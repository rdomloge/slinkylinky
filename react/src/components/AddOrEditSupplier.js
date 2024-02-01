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
import SupplierSemRushTraffic from "./SupplierSemRushTraffic";

export default function AddOrEditSupplier({supplier}) {
    const { data: session } = useSession();
    const [errorMsg, setErrorMsg] = useState()
    const [showModal, setShowModal] = useState(false)

    function handleError(message) {
        setErrorMsg("Create failed: "+message)
    }

    function addProtocol(url) {
        if (!/^(?:f|ht)tps?\:\/\//i.test(url)) {
            url = "https://" + url;
        }
        return url;
    }

    function url_domain(data) {
        let domain =  new URL(addProtocol(data))
        let hostname = domain.hostname
        return hostname.replace('www.','');
    }

    function lookupDa(domain) {
        const url = "/.rest/mozsupport/checkdomain?domain="+domain
        fetch(url, {method: 'GET', headers: {'user': session.user.email}})
        .then( (resp) => {
            if(resp.ok) {
                resp.json().then( (data) => {
                    supplier.da = data.domain_authority
                })
            }
            else {
                handleError("Unknown error: "+resp.status)
            }
        })
        .catch(err => { handleError("Oops") });
    }

    function displaySemData() {
        supplier.domain = url_domain(supplier.website)
        lookupDa(supplier.domain)
        setShowModal(true)
    }
    
    function submitHandler() {
        console.log("Updating supplier: "+JSON.stringify(supplier))
        const supplierUrl = "/.rest/suppliers"
        const patchData = {...supplier}
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
                    location.href = "/supplier/"+supplier.id;
                }
                else {
                    handleError(resp.status === 409 ? "Website already exists" : "Unknown error: "+resp.status)
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
                    const locationUrl = resp.headers.get('Location')
                    location.href = "/supplier/"+locationUrl.substring(locationUrl.lastIndexOf('/')+1);
                }
                else {
                    handleError(resp.status === 409 ? "Website already exists" : "Unknown error: "+resp.status)
                }
            })
            .catch(err => { 
                handleError("Oops") });
        }
    }

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


                <div className='w-1/4 inline-block pr-8'> 
                    <TextInput initialValue={supplier.name} label={"Name"} changeHandler={(e)=>supplier.name = e} /> 
                </div>
                <div className='w-28 inline-block pr-8'>
                    <NumberInput label={"DA"} changeHandler={(e)=>supplier.da = e} stateValue={supplier.da}/>
                </div>
                <div className='w-1/4 inline-block pr-8'>
                    <TextInput initialValue={supplier.website} label={"Website"} changeHandler={(e)=>supplier.website = e}/> 
                </div>
                <div className='w-1/4 inline-block pr-8'>
                    <TextInput initialValue={supplier.source} label={"Source"} changeHandler={(e)=>supplier.source = e}/> 
                </div>


                <div className='w-1/3 inline-block pr-8'>
                    <TextInput initialValue={supplier.email} label={"Email"} changeHandler={(e)=>supplier.email = e}/> 
                </div>
                
                
                <div className='w-20 inline-block pr-8 mt-8'>
                    <TextInput initialValue="£" label="Currency" changeHandler={(e)=>supplier.weWriteFeeCurrency = e} maxLen={1}/>
                </div>
                <div className='w-28 inline-block pr-8'>
                    <NumberInput initialValue={supplier.weWriteFee} label={"Fee"} changeHandler={(e)=>supplier.weWriteFee = e}/>
                </div>

                {supplier.id == null ?
                    <div className="inline-block">
                        <label className="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" htmlFor="srButton">
                            Fetch DA and load SEM rush traffic (cost attached)
                        </label>
                        <StyledButton id="srButton" label="$ LOAD $" type="tertiary"
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
                {showModal ?
                    <Modal title={"SEM rush traffic // "+supplier.domain} dismissHandler={()=>setShowModal(false)} width={"w-2/3"}>
                        <SupplierSemRushTraffic supplier={supplier} adhoc={true}/>
                    </Modal>
                : 
                    null
                }
            </div>
            : <p>Loading supplier</p>}
        </>
        
    )
}