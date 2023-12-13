'use client'

import '@/styles/globals.css'
import CategoriesCard from '@/components/categoriescard'
import Image from 'next/image'
import Icon from '@/components/shoppingcart.png'
import NiceDate from './Date'
import Link from 'next/link'

export default function LinkDemandCard({linkdemand, fullfilable, editable}) {
    
    if(linkdemand === null) return <p>NULL</p>;
    else {
        return (
            <div className="card list-card flex">
                <div className='flex-1'>
                    <Image src={Icon} width={32} height={32} alt="Shopping cart icon"/>
                    <div>{linkdemand.name}</div>
                    <Link href={linkdemand.url} target='_blank'>
                        <div>{linkdemand.url}</div>
                    </Link>
                    <div>Domain Authority needed {linkdemand.daNeeded}</div>
                    <div><NiceDate isostring={linkdemand.requested}/></div>
                    <p>Created by {linkdemand.createdBy}</p>
                    <CategoriesCard categories={linkdemand.categories}/>
                </div>
                <div className='flex-initial'>
                    {fullfilable ?
                    <Link href={'/supplier/search/'+linkdemand.id}>
                        <span className='block text-lg font-bold'>Fullfil</span>
                    </Link>
                    :null}
                    {editable ?
                    <Link href={'/demand/'+linkdemand.id}>
                        <span className='block text-right'>Edit</span>
                    </Link>
                    :null}
                </div>
            </div>
        );
***REMOVED***
}