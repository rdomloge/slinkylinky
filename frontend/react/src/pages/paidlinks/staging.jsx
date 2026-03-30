import React, {useState, useEffect} from 'react'
import { useSearchParams } from 'react-router-dom'
import { useAuth } from "@/auth/AuthProvider";

import DemandCard from '@/components/DemandCard'
import SupplierCard from '@/components/SupplierCard'
import Layout from '@/components/layout/Layout'
import SelectableDemandCard from '@/components/SelectableDemandCard'
import Loading from '@/components/Loading';
import ErrorMessage from '@/components/atoms/Messages';
import ProposalValidationPanel from '@/components/ProposalWarnings';
import { ClickHandlerButton } from '@/components/atoms/Button';
import { fetchWithAuth } from '@/utils/fetchWithAuth';

function parseId(entity) {
    const url = entity._links.self.href;
    const id = url.substring(url.lastIndexOf('/')+1);
    return id;
}

export default function App() {
    const { user } = useAuth();
    const [searchParams] = useSearchParams()

    const [demand, setDemand] = useState(null);
    const [supplier, setSupplier] = useState(null);
    const [otherDemands, setOtherDemands] = useState(null);
    const [selectedOtherDemands, setSelectedOtherDemands] = useState([]);
    const [error, setError] = useState(null);
    const [submitError, setSubmitError] = useState(null);
    const [ready, setReady] = useState(false);


    const handleSubmit = (supplierId) => {

        const aggregateDemand = selectedOtherDemands.concat([demand]);
        const proposalUrl = "/.rest/proposalsupport/createProposal?supplierId=" + supplierId + "&demandIds=" + aggregateDemand.map((d) => d.id).join(',');

        fetchWithAuth(proposalUrl, {
            method: 'POST',
            headers: {'Content-Type':'application/json', 'user': user.email},
        })
        .then( (resp) => {
            if(resp.ok) {
                const locationUrl = resp.headers.get('Location')
                location.href = "/proposals/"+locationUrl.substring(locationUrl.lastIndexOf('/')+1);
            }
            else {
                resp.json()
                    .then(data => setSubmitError(data.error || ("Failed to create proposal (" + resp.status + ")")))
                    .catch(() => setSubmitError("Failed to create proposal (" + resp.status + ")"));
            }
        });
    }

    useEffect(
        () => {
            if(searchParams.has('supplierId') && searchParams.has('demandId')) {
                const supplierId = searchParams.get('supplierId')
                const demandId = searchParams.get('demandId')
                const demandUrl = "/.rest/demands/"+ demandId+"?projection=fullDemand";
                const supplierUrl = "/.rest/suppliers/"+ supplierId+"?projection=fullSupplier";
                const otherDemandsUrl = "/.rest/demands/search/findDemandForSupplierId?supplierId="
                                            + supplierId + "&demandIdToIgnore="+demandId+"&projection=fullDemand";

                Promise.all([fetchWithAuth(demandUrl), fetchWithAuth(supplierUrl), fetchWithAuth(otherDemandsUrl)])
                    .then(([resDemand, resSupplier, resOtherDemands]) => {
                        if(!resDemand.ok || !resSupplier.ok || !resOtherDemands.ok) {
                            throw new Error("Could not fetch data");
                        }
                        return Promise.all([resDemand.json(), resSupplier.json(), resOtherDemands.json()])
                    })
                    .then(([dataDemand, dataSupplier, dataOtherDemands]) => {
                        dataDemand.id = demandId; // eurgh... have to find a way to get spring data rest to include the IDs
                        setDemand(dataDemand);
                        setSupplier(dataSupplier);
                        setOtherDemands(dataOtherDemands);
                    })
                    .catch((error) => {
                        setError(error.message);
                    });

            }
        }, [searchParams]
    );

    return (
        <Layout pagetitle='Proposal staging'
            headerTitle="Proposal Staging"
            headerActions={<ClickHandlerButton label="Submit" clickHandler={() => handleSubmit(searchParams.get('supplierId'))} disabled={!ready} id="submitProposal"/>}
        >

            {submitError && (
                <div className="px-6 pb-2">
                    <ErrorMessage message={submitError}/>
                </div>
            )}

            {( !error && supplier && demand && otherDemands) ?
                <>
                <ProposalValidationPanel primaryDemand={demand}
                    otherDemands={selectedOtherDemands}
                    supplier={supplier}
                    readinessCallback={(ready) => setReady(ready)}
                    />
                <div className="grid grid-cols-2 gap-4 px-6 pb-6">
                    <div>
                        <SupplierCard supplier={supplier}/>
                        <DemandCard demand={demand}/>
                    </div>
                    <div>
                        <p className="text-xs font-semibold text-slate-400 uppercase tracking-wide mb-3 mt-1">Other matching demand</p>
                        {otherDemands.length === 0 && (
                            <p className="text-sm text-slate-400 italic">No other matching demand for this supplier.</p>
                        )}
                        {otherDemands.map( (d,index) =>
                            <SelectableDemandCard
                                    onSelectedHandler={() => {
                                        selectedOtherDemands.push(d);
                                        setSelectedOtherDemands([...selectedOtherDemands]);
                                    }}
                                    onDeselectedHandler={() => {
                                        const pos = selectedOtherDemands.indexOf(d);
                                        if(pos != -1)  selectedOtherDemands.splice(pos, 1);
                                        setSelectedOtherDemands([...selectedOtherDemands]);
                                    }}
                                    key={index}>
                                <DemandCard demand={d} />
                            </SelectableDemandCard>
                            )}
                    </div>
                </div>
                </>
            :
                <Loading error={error} />
            }

        </Layout>
    );
}
