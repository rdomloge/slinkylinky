import { useAuth } from "@/auth/AuthProvider";
import CategorySelector from "@/components/CategorySelector";
import TextInput from '@/components/atoms/TextInput';
import SessionButton from "./atoms/Button";
import { fixForPosting } from "./CategoryUtil";
import { useState } from "react";
import { fetchWithAuth } from "@/utils/fetchWithAuth";


export default function AddOrEditDemandSite({demandSite}) {

    const { user } = useAuth();
    const [demandSiteName, setDemandSiteName] = useState(demandSite.name)
    const [demandSiteUrl, setDemandSiteUrl] = useState(demandSite.url)

    function submitHandler() {
        
        console.log("Demand: "+JSON.stringify(demandSite))
        const restUrl = "/.rest/demandsites"
        delete demandSite.domain
        demandSite.name = demandSiteName
        demandSite.url = demandSiteUrl
                
        fixForPosting(demandSite)

        if(demandSite.id) {
            demandSite.updatedBy = user.email

            fetchWithAuth(restUrl+"/"+demandSite.id, {
                method: 'PATCH',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(demandSite)
            }).then(resp => {
                if(resp.ok) {
                    location.href = "/demandsites";
                }
                else {
                    console.log("Patch failed: "+JSON.stringify(resp))
                }
            })
        }
    }

    function categoryChangeHandler(categories) {
        const categoryHrefs = categories.map(c => c.value)
        demandSite.categories = categoryHrefs
    }

    return (
        <div className="px-6 pb-6 max-w-2xl">
            <div className="card demandsite-card p-6 flex flex-col gap-5">

                {/* Card header with DemandSite identity */}
                <div className="flex items-center justify-between">
                    <h2 className="font-semibold text-slate-800" style={{fontFamily: "'Outfit', sans-serif", fontSize: '0.95rem', letterSpacing: '-0.01em'}}>
                        {demandSite.id ? 'Edit demand site' : 'New demand site'}
                    </h2>
                    <span className="entity-badge entity-badge-demandsite">Demand Site</span>
                </div>

                <TextInput label="Name" binding={demandSiteName} changeHandler={(e) => setDemandSiteName(e)}/>
                <TextInput label="URL" binding={demandSiteUrl} changeHandler={(e) => setDemandSiteUrl(e)}/>
                <CategorySelector changeHandler={categoryChangeHandler} label="Categories" initialValue={demandSite.categories}/>

                <div className="border-t" style={{borderColor: 'var(--demandsite-border)'}}/>

                <div>
                    <button onClick={submitHandler}
                        className="w-full py-2.5 px-4 rounded-lg text-white font-semibold text-sm transition-all"
                        style={{background: 'var(--demandsite-color)'}}>
                        Save demand site
                    </button>
                </div>
            </div>
        </div>
    );
}