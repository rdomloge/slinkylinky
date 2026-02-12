import AddOrEditDemandSite from "@/components/AddOrEditDemandSite";
import React, {useState, useEffect} from 'react';
import { useParams } from 'react-router-dom'
import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import Loading from "@/components/Loading";
import { fetchWithAuth } from "@/utils/fetchWithAuth";

export default function DemandSite() {
    const { demandsiteid } = useParams()
    const [demandSite, setDemandSite] = useState(null)
    const [error, setError] = useState(null)

    useEffect(
        () => {
            const demandSiteUrl = "/.rest/demandsites/"+demandsiteid + "?projection=fullDemandSite"

            fetchWithAuth(demandSiteUrl)
                .then(res => res.json())
                .then(data => setDemandSite(data))
                .catch(err => setError(err));
        }, [demandsiteid]);

    return (
        <Layout pagetitle="Edit demand site">
            <PageTitle title="Edit demand site" id="demandsite-detail-title-id"/>
            {demandSite ? 
                <AddOrEditDemandSite demandSite={demandSite}/>
            : 
                <Loading error={error}/> 
            }
        </Layout>
    );
}