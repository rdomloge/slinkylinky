import { useAuth } from "@/auth/AuthProvider";

import CategorySelector from '@/components/CategorySelector'
import Icon from '@/assets/shipping.png'
import TextInput from '@/components/atoms/TextInput'
import NumberInput from '@/components/atoms/NumberInput'
import React, {useEffect, useState} from 'react';
import DisableToggle from './atoms/Toggle'
import { fixForPosting } from "./CategoryUtil";
import { StyledButton } from "./atoms/Button";
import Modal from "./atoms/Modal";
import SupplierSemRushTraffic from "./SupplierStats";
import { checkIfSupplierExists, checkIfSupplierIsBlacklisted, url_domain, validDomain } from "./Util";
import { WarningMessage } from "./atoms/Messages";
import { fetchWithAuth } from "@/utils/fetchWithAuth";

export default function AddOrEditSupplier({supplier,
        supplierName = '', setSupplierName,
        supplierWebsite='', setSupplierWebsite,
        supplierSource='', setSupplierSource,
        supplierEmail='', setSupplierEmail,
        supplierFee=0, setSupplierFee,
        bulkMode=false,
        bulkSupplierAddedHandler}) {

    if( ! supplier) throw new Error("Supplier cannot be null. If you are loading it, wrap this component in a null check before using it")

    const { user } = useAuth();
    const [errorMsg, setErrorMsg] = useState()
    const [showStatsModal, setShowStatsModal] = useState(false)
    const [showBlacklistModal, setShowBlacklistModal] = useState(false)

    const [supplierDa, setSupplierDa] = useState(supplier.da)
    const [supplierSpamScore, setSupplierSpamScore] = useState(0)
    const [supplierCurrency, setSupplierCurrency] = useState(supplier.weWriteFeeCurrency)

    const [supplierAlreadyExists, setSupplierAlreadyExists] = useState(false)
    const [supplierIsBlackListed, setSupplierIsBlackListed] = useState(false)
    const [showStatsButton, setShowStatsButton] = useState(false)
    const [dataPoints, setDataPoints] = useState([])

    useEffect(() => {
        if(supplierWebsite && supplierWebsite !== supplier.website) {
            setSupplierAlreadyExists(false)
            setSupplierIsBlackListed(false)
            supplierWebsiteChangeHandler(supplierWebsite)
        }
    }, [supplierWebsite])


    function handleError(message) {
        setErrorMsg("Create failed: "+message)
    }

    async function supplierWebsiteChangeHandler(e) {
        setSupplierWebsite(e)
        if(validDomain(e)) {
            const existsAlready = await checkIfSupplierExists(e)
            if(existsAlready) { setSupplierAlreadyExists(true) }

            const blacklisted = await checkIfSupplierIsBlacklisted(e)
            if(blacklisted) { setSupplierIsBlackListed(true) }

            setShowStatsButton(!existsAlready && !blacklisted)
        }
        else {
            setShowStatsButton(false)
        }
    }

    function lookupDa(domain) {
        const url = "/.rest/mozsupport/checkdomain?domain="+domain
        fetchWithAuth(url, {method: 'GET'})
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

        fetchWithAuth(url, {method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(dataPoints)})

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

            patchData.updatedBy = user.email

            fetchWithAuth(supplierUrl+"/"+supplier.id, {
                method: 'PATCH',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(patchData)
            })
            .then( (resp) => {
                if(resp.ok) {
                    location.href = "/supplier"
                }
                else {
                    handleError(resp.status === 409 ? "Website already exists" : "Unknown error: "+resp.statusText)
                }
            })
            .catch(err => { handleError("Oops") });
        }
        else {

            patchData.createdBy = user.email
            if( ! patchData.weWriteFeeCurrency) patchData.weWriteFeeCurrency = "£"

            fetchWithAuth(supplierUrl, {
                method: 'POST',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(patchData)
            })
            .then( (resp) => {
                if(resp.ok) {
                    if(bulkMode) {
                        bulkSupplierAddedHandler(supplierWebsite);
                        setSupplierDa(0);
                        setSupplierWebsite('');
                        setSupplierFee(0);
                    }
                    else {
                        location.href = "/supplier"
                    }
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
                <div className="px-6 pb-6">
                    {/* Form card */}
                    <div className="bg-white rounded-xl border border-slate-200 shadow-sm p-6">

                        {/* Card header: icon + actions */}
                        <div className="flex items-center justify-between mb-6 pb-4 border-b border-slate-100">
                            <div className="flex items-center gap-2">
                                <img src={Icon} width={28} height={28} alt="Supplier icon" className="opacity-50"/>
                                <span className="text-sm font-medium text-slate-400">Supplier details</span>
                            </div>
                            <div className="flex items-center gap-4">
                                {errorMsg && <p className="text-sm text-red-600">{errorMsg}</p>}
                                <DisableToggle changeHandler={(e) => supplier.disabled = e} initialValue={supplier.disabled}/>
                                <StyledButton label="Submit" type="primary" submitHandler={submitHandler} extraClass="!m-0" enabled={submitEnabled()}/>
                            </div>
                        </div>

                        {/* Row 1: Name / DA / Website */}
                        <div className="grid grid-cols-[1fr_6rem_1fr] gap-4 mb-4">
                            <TextInput binding={supplierName} label="Name (min. 3)" changeHandler={(e)=>setSupplierName(e)} id="nameInput"/>
                            <NumberInput label="DA" changeHandler={(e) => setSupplierDa(e)} binding={supplierDa} id="daInput"/>
                            <div>
                                <TextInput binding={supplierWebsite} label="Website" changeHandler={(e)=>supplierWebsiteChangeHandler(e)} id="websiteInput"/>
                                {supplierAlreadyExists &&
                                    <p id="supplierExistsMessage" className="mt-1 text-xs text-red-600">
                                        <span className="font-medium">Error!</span> Supplier exists.
                                    </p>
                                }
                                {supplierIsBlackListed &&
                                    <p id="blacklistedSupplierMessage" className="mt-1 text-xs text-red-600">
                                        <span className="font-medium">Error!</span> Supplier is blacklisted.
                                    </p>
                                }
                            </div>
                        </div>

                        {/* Row 2: Source / Email */}
                        <div className="grid grid-cols-[1fr_2fr] gap-4 mb-4">
                            <TextInput binding={supplierSource} label="Source" changeHandler={(e)=>setSupplierSource(e)} id="sourceInput"/>
                            <TextInput binding={supplierEmail} label="Email" changeHandler={(e)=>setSupplierEmail(e)} id="emailInput"/>
                        </div>

                        {/* Row 3: Currency / Fee / Load stats */}
                        <div className="flex items-end gap-4 mb-6">
                            <div className="w-20">
                                <TextInput binding={supplierCurrency} label="Currency" changeHandler={(e)=>setSupplierCurrency(e)} maxLen={1} id="currencyInput"/>
                            </div>
                            <div className="w-32">
                                <NumberInput binding={supplierFee} label="Fee" changeHandler={(e)=>setSupplierFee(e)} id="costInput"/>
                            </div>
                            {supplier.id == null && showStatsButton &&
                                <div>
                                    <p className="text-xs font-semibold text-slate-400 uppercase tracking-wider mb-2">Fetch DA + SemRush traffic</p>
                                    <StyledButton id="srButton" label="Load" type="risky" submitHandler={()=>displaySemData()} extraClass="!m-0"/>
                                </div>
                            }
                        </div>

                        {/* Categories */}
                        <div className="max-w-2xl">
                            <CategorySelector label="Categories"
                                changeHandler={(e)=> supplier.categories = e}
                                initialValue={supplier.categories}/>
                        </div>
                    </div>

                    {showStatsModal &&
                        <Modal title={"SEM rush traffic // "+supplier.domain} dismissHandler={()=>setShowStatsModal(false)} width={"w-2/3"} id="stats-modal">
                            <StyledButton label="Blacklist" type="risky" submitHandler={()=>setShowBlacklistModal(true)} extraClass="mt-0 float-right"/>
                            <span className="inline-block mr-6">Domain authority:
                                <span className="text-2xl"> {supplierDa}</span>
                            </span>
                            <span>Spam score:
                                <span className="text-2xl"> {supplierSpamScore}</span>
                            </span>
                            <SupplierSemRushTraffic supplier={supplier} adhoc={true} dataListener={(data) => setDataPoints(data)}/>
                        </Modal>
                    }

                    {showBlacklistModal &&
                        <Modal title={"Blacklist supplier"} dismissHandler={()=>setShowBlacklistModal(false)} width={"w-1/2"} id="blacklist-modal">
                            <p className="p-2 text-2xl">{"Are you sure you want to blacklist "}<span className="font-bold">{supplierWebsite}</span>{"?"}</p>
                            <WarningMessage message={"This is permanent action and future users will be prevented from creating Suppliers with this domain"}/>
                            <StyledButton label="Blacklist" type="risky" submitHandler={()=>doBlackList()} extraClass="mt-4 float-right"/>
                        </Modal>
                    }
                </div>
            :
                <p>Loading supplier</p>
            }
        </>
    )
}
