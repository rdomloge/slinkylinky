import { DemandSiteListItemLite } from "@/components/DemandSite";
import Loading from "@/components/Loading";

export default function DemandSiteGrid({demandSites}) {

    return (
        <div className="grid grid-cols-3">
            {demandSites ?
                demandSites.map( (ds,index) => (
                    <DemandSiteListItemLite demandSite={ds} key={index} id={"demandsite-"+index} deleteHandler={()=>deleteDemandSite(ds)} />
                ))
            : <Loading/> }
        </div>
    )
}