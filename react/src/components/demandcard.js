'use client'

import '@/styles/globals.css'
import CategoriesCard from '@/components/categoriescard'
import Image from 'next/image'
import Icon from '@/components/shoppingcart.png'
import NiceDate from './atoms/DateTime'
import Link from 'next/link'
import { SessionBlock } from './atoms/Button'

export default function DemandCard({demand, fullfilable, editable}) {
    
    if(demand === null) return <p>NULL</p>;
    else {
        return (
            <div className="card list-card flex">
                <div className='flex-1'>
                    <Image src={Icon} width={32} height={32} alt="Shopping cart icon"/>
                    <div>{demand.name}</div>
                    <Link href={demand.url} target='_blank'>
                        <div>{demand.url}</div>
                    </Link>
                    <div>Anchor: {demand.anchorText}</div>
                    <div>Domain Authority needed {demand.daNeeded}</div>
                    <div><NiceDate isostring={demand.requested}/></div>
                    <p>Created by {demand.createdBy}</p>
                    <CategoriesCard categories={demand.categories}/>
                </div>
                <SessionBlock>
                    <div className='flex-initial'>
                        {fullfilable ?
                        <Link href={'/supplier/search/'+demand.id}>
                            <span className='block text-lg font-bold'>Fullfil</span>
                        </Link>
                        :null}
                        {editable ?
                        <Link href={'/demand/'+demand.id}>
                            <span className='block text-right'>Edit</span>
                        </Link>
                        :null}
                    </div>
                </SessionBlock>
            </div>
        );
    }
}