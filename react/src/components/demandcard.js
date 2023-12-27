'use client'

import '@/styles/globals.css'
import CategoriesCard from '@/components/categoriescard'
import Image from 'next/image'
import CartIcon from '@/components/shoppingcart.png'
import AnchorIcon from '@/components/anchor.svg'
import CalendarIcon from '@/components/calendar.svg'
import LinkIcon from '@/components/link.svg'
import DaIcon from '@/components/authority.svg'
import NiceDate from './atoms/DateTime'
import Link from 'next/link'
import { SessionBlock } from './atoms/Button'

export default function DemandCard({demand, fullfilable, editable}) {
    
    if(demand === null) return <p>NULL</p>;
    else {
        return (
            <div className="card list-card grid grid-cols-10">
                <div className='col-span-9'>
                    <Image src={CartIcon} width={32} height={32} alt="Shopping cart icon"/>
                    <div className='text-xl my-2'>{demand.name}</div>
                    <Link href={demand.url} target='_blank' className='truncate'>
                        <Image className='inline-block mr-2' src={LinkIcon} alt="link" width={20} height={20}/>
                        <p className='inline-block align-middle truncate w-5/6'>{demand.url}</p>
                    </Link>
                    <div>
                        <Image className='inline-block mr-2' src={AnchorIcon} alt="anchor" width={20} height={20}/> 
                        <span className='align-middle'>{demand.anchorText}</span>
                    </div>
                    <div>
                        <Image className='inline-block mr-2' src={DaIcon} alt="da" width={20} height="auto"/>
                        <span className='align-middle text-lg font-bold'>{demand.daNeeded}</span>
                    </div>
                    <div className='align-middle'>
                        <Image className='inline-block mr-2' src={CalendarIcon} alt="calendar" width={20} height={20}/>
                        <NiceDate isostring={demand.requested}/>
                    </div>
                    <p>Created by {demand.createdBy}</p>
                    <CategoriesCard categories={demand.categories}/>
                </div>
                <SessionBlock>
                    <div className=''>
                        {fullfilable ?
                        <Link href={'/supplier/search/'+demand.id}>
                            <span className='block text-lg font-bold text-right'>Fullfil</span>
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
***REMOVED***
}