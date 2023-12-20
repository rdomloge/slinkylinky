import Link from "next/link";
import { CategoryLite } from "./category";
import Image from "next/image";
import ArrowIcon from '@/pages/demand/left-arrow.svg'
import SessionButton, { SessionBlock } from "./atoms/Button";

export default function DemandSiteSearchResult({demandSite, selectedHandler}) {
    return (
        <div className="card list-card flex">
            <div className="flex-0 pr-4 m-auto">
                <button onClick={(e) => 
                        selectedHandler(demandSite)}>
                <Image src={ArrowIcon} alt="Arrow icon" height={30} width={30} />
                </button>
            </div>
            <div className="flex-1">
                <span className="float-right bg-red-100 text-blue-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded-full dark:bg-gray-700 dark:text-blue-400 border border-blue-400">
                    {demandSite.demands.length}
                </span>
                <p className="text-lg">{demandSite.name}</p>
                <p className="mb-6">{demandSite.domain}</p>
                {demandSite.categories.map( (c,index) => <CategoryLite category={c} key={index}/> )}
            </div>
        </div>
    );
}

export function DemandSiteListItemLite({demandSite}) {
    return (
        <div className="card list-card">
            <SessionBlock>
                <Link href={"/demandsites/"+demandSite.id}>
                    <p className='text-right float-right'>Edit</p>
                </Link>
            </SessionBlock>
            <p className="text-lg">{demandSite.name}</p>
            <p>{demandSite.domain}</p>
            {demandSite.categories.map( (c,index) =>
                <CategoryLite category={c} key={index}/>
            )}
        </div>
    );
}