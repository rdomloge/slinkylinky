import React, {useState, useEffect} from 'react'
import { useParams } from 'react-router-dom'

import DemandCard from '@/components/DemandCard'
import SupplierCard from '@/components/SupplierCard'
import Layout from '@/components/layout/Layout'
import SessionButton, { ClickHandlerButton } from '@/components/atoms/Button'
import Modal from '@/components/atoms/Modal'
import TextInput from '@/components/atoms/TextInput'
import Loading from "@/components/Loading";
import { Toggle } from '@/components/atoms/Toggle'
import { fetchWithAuth } from "@/utils/fetchWithAuth";

export default function App() {
    const { demandid } = useParams()

    const [demand, setDemand] = useState(null);
    const [suppliers, setSuppliers] = useState(null);
    const [existingLinkCount, setExistingLinkCount] = useState()
    const [showModal, setShowModal] = useState(false);
    const [newSupplierName, setNewSupplierName] = useState();
    const [supplierUsageCount, setSupplierUsageCount] = useState();
    const [responsiveness, setResponsiveness] = useState();
    const [error, setError] = useState();
    const [maxSpamScore, setMaxSpamScore] = useState(6);

    useEffect(() => {
        const demandUrl = "/.rest/demands/" + demandid + "?projection=fullDemand";
        fetchWithAuth(demandUrl)
            .then(res => {
                if (!res.ok) throw new Error("Could not load demand");
                return res.json();
            })
            .then(dataDemand => {
                setDemand(dataDemand);
                fetchWithAuth("/.rest/paidlinks/search/countByDemand_domain?domain=" + dataDemand.domain)
                    .then(resCount => resCount.json())
                    .then(count => setExistingLinkCount(count));
                fetchWithAuth("/.rest/stats/responsiveness/all")
                    .then(res => res.ok ? res.json() : {})
                    .then(data => setResponsiveness(data))
                    .catch(() => {});
            })
            .catch(err => setError(err));
    }, [demandid]);

    useEffect(() => {
        if (!demandid) return;
        let url = "/.rest/supplierSupport/suppliersForDemand?demandId=" + demandid;
        if (maxSpamScore != null) url += "&maxSpamScore=" + maxSpamScore;
        setSuppliers(null);
        fetchWithAuth(url)
            .then(res => {
                if (!res.ok) throw new Error("Could not load suppliers");
                return res.json();
            })
            .then(dataSuppliers => {
                setSuppliers(dataSuppliers);
                if (dataSuppliers.length) {
                    const ids = dataSuppliers.map(s => s.id).join(",");
                    fetchWithAuth("/.rest/paidlinksupport/getcountsforsuppliers?supplierIds=" + ids)
                        .then(resCount => resCount.json())
                        .then(counts => setSupplierUsageCount(counts));
                } else {
                    setSupplierUsageCount({});
                }
            })
            .catch(err => setError(err));
    }, [demandid, maxSpamScore]);

    function create3rdPartyProposal() {
        console.log("Creating 3rd party Supplier: "+newSupplierName);
        setShowModal(false);

        const combiUrl = "/.rest/proposalsupport/resolveProposal3rdParty?name="+newSupplierName+"&demandId="+demand.id

        fetchWithAuth(combiUrl, {
            method: 'POST',
            headers: {'Content-Type':'application/json'}
        })
        .then( (resp) => {
            if(resp.ok) {
                const locationUrl = resp.headers.get('Location')
                location.href = "/proposals/"+locationUrl.substring(locationUrl.lastIndexOf('/')+1);
            }
        })
    }

    return (
        <Layout pagetitle="Supplier search" headerTitle="Find a matching supplier">

            {error || !demand ?
                <Loading error={error}/>
            :
                <>
                    {/* Demand + historical links */}
                    <div className="flex gap-4 px-6 mb-6">
                        <div className="flex-1 min-w-0">
                            <DemandCard demand={demand}/>
                        </div>

                        <div className="w-64 shrink-0 bg-white rounded-xl border border-slate-200 shadow-sm p-5 flex flex-col gap-4">
                            <div>
                                <p className="text-xs font-semibold text-slate-400 uppercase tracking-wider mb-1">Historical links</p>
                                <div className="flex items-baseline gap-1.5">
                                    <span className="text-4xl font-bold text-slate-800">{existingLinkCount}</span>
                                    <span className="text-sm text-slate-500">tracked for this domain</span>
                                </div>
                            </div>
                            <SessionButton label="Use 3rd party" clickHandler={() => setShowModal(true)}/>
                        </div>
                    </div>

                    {/* Matching suppliers header */}
                    <div className="flex items-center gap-3 px-6 mb-3">
                        <h2 className="text-lg font-semibold text-slate-700">Matching suppliers</h2>
                        {suppliers &&
                            <span className="text-xs font-medium text-slate-400 bg-slate-100 px-2.5 py-1 rounded-full">
                                {suppliers.length}
                            </span>
                        }
                        <div className="ml-auto">
                            <Toggle
                                initialValue={maxSpamScore != null}
                                label="Hide high spam (>6%)"
                                changeHandler={checked => setMaxSpamScore(checked ? 6 : null)}
                            />
                        </div>
                    </div>

                    {/* Supplier grid */}
                    {suppliers ?
                        <SupplierList suppliers={suppliers} demand={demand}
                            demandid={demandid} usages={supplierUsageCount} responsiveness={responsiveness}/>
                    : null}
                </>
            }

            {showModal &&
                <Modal dismissHandler={() => setShowModal(false)} title="3rd Party options">
                    <TextInput label="Supplier name" binding={newSupplierName} changeHandler={(e) => setNewSupplierName(e)}/>
                    <div className="mt-4">
                        <ClickHandlerButton label="Create" clickHandler={() => create3rdPartyProposal()}/>
                    </div>
                </Modal>
            }
        </Layout>
    );
}

function selectSupplier(s, props) {
    window.location.href="/paidlinks/staging?supplierId="+s.id+"&demandId="+props.demandid
}

function SupplierList(props) {
    if(props.suppliers === null || props.demand === null) return <p>Loading...</p>;
    return (
        <div className="grid grid-cols-3 gap-4 px-6 pb-6">
            {props.suppliers.map((s, index) => (
                <div key={index} id={"selectableSupplierCard-"+index}>
                    <SupplierCard supplier={s} linkable={true} usages={props.usages} responsiveness={props.responsiveness}
                        selectHandler={() => selectSupplier(s, props)}/>
                </div>
            ))}
        </div>
    );
}
