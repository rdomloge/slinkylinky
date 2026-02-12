import React, {useState, useEffect} from 'react'
import { useParams } from 'react-router-dom'
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout/Layout'
import AddOrEditDemand from '@/components/AddOrEditDemand'
import Loading from '@/components/Loading'
import { fetchWithAuth } from '@/utils/fetchWithAuth'

export default function Demand() {
    const { demandid } = useParams()
    const [demand, setDemand] = useState(null)
    const [error, setError] = useState(null)

    useEffect(
        () => {
            const demandUrl = '/.rest/demands/'+ demandid+"?projection=fullDemand";
            fetchWithAuth(demandUrl)
                .then(res => res.json())
                    .then(json => {
                        json.id = demandid;
                        setDemand(json);
                    })
                .catch(err => setError("Could not load Demand: "+err.statusMessage));
        }, [demandid]
    )

    return (
        <Layout pagetitle='Edit demand'>
            <PageTitle id="demand-edit-id" title="Edit Demand"/>
            {demand ? 
                <AddOrEditDemand demand={demand}/>
            : 
                <Loading error={error}/> 
            }
        </Layout>
    );
}