'use client'

import '@/styles/globals.css'
import CategoriesCard from '@/components/categoriescard'
import Image from 'next/image'
import CartIcon from '@/components/shoppingcart.png'
import AnchorIcon from '@/components/anchor.svg'
import CalendarIcon from '@/components/calendar.svg'
import LinkIcon from '@/components/link.svg'
import DaIcon from '@/components/authority.svg'
import LSLogo from '@/components/linksync-logo.png'
import SLLogo from '@/components/logo.png'
import NiceDate from './atoms/DateTime'
import WordCountIcon from '@/components/text-word-count.svg'
import Link from 'next/link'
import { SessionBlock, StyledButton } from './atoms/Button'
import { useState } from 'react'
import Modal from './atoms/Modal'
import { useSession } from 'next-auth/react'
import { addProtocol } from './Util'

export default function DemandCard({demand, fullfilable, editable, id, deleteCascader}) {

    const [showDeleteModal, setShowDeleteModal] = useState(false)
    const { data: session } = useSession();

    function deleteHandler() {
        setShowDeleteModal(false)
        fetch('/.rest/demandsupport/delete?demandId='+demand.id, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
                'user': session.user.email
            },
            body: JSON.stringify({id: demand.id})
        })
        .then(res => {
            if (res.ok) {
                // window.location.reload()
                deleteCascader(demand)
            }
        })
    }
    
    return (
        <div className={"card list-card grid grid-cols-10"} id={id}>
            <div className='col-span-9'>
                <Image src={CartIcon} width={32} height={32} alt="Shopping cart icon"/>
                <div className='text-xl my-2'>{demand.name}</div>
                <Link href={addProtocol(demand.url)} target='_blank' className='truncate'>
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
                <div>
                    <Image className='inline-block mr-2' src={WordCountIcon} alt="words" width={22} height="auto"/>
                <span className='align-middle text-lg'>{demand.wordCount} words</span>
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
                    <>
                    <Link href={'/demand/'+demand.id}>
                        <span className='block text-right'>Edit</span>
                    </Link>
                    <div className='flex justify-end'>
                        <StyledButton label='Delete' type='risky' submitHandler={()=> setShowDeleteModal(true)} isText={true}/>
                    </div>
                    </>
                    :null}
                </div>
            </SessionBlock>
            
            {'LinkSync' === demand.source ? <Image src={LSLogo} height={25} alt="LinkSync logo" className='float-right '/> : null}
            {'SlinkyLinky' === demand.source ? <Image src={SLLogo} height={20} alt="LinkSync logo" className='float-right'/> : null}
            
            {showDeleteModal ?
                <Modal title='Delete demand' dismissHandler={()=> setShowDeleteModal(false)}>
                    <p>Are you sure you want to delete this demand?</p>
                    <p className='font-bold text-center py-2'>&apos;{demand.name}&apos;</p>
                    <p>Created by {demand.createdBy}, requested on {new Date(demand.requested).toLocaleDateString()}</p>
                    <p className='text-red-500 text-center py-2'>This action cannot be undone.</p>
                    <div className='flex justify-end'>
                        <StyledButton label='Delete' type='risky' submitHandler={deleteHandler}/>
                    </div>
                </Modal>
            :
                null
            }
        </div>
    );
}