'use client'

import CategoriesCard from '@/components/categoriescard'
import Image from 'next/image'
import Icon from '@/components/shipping.png'
import DaIcon from '@/components/authority.svg'
import LinkIcon from '@/components/link.svg'
import EmailIcon from '@/components/email.svg'
import MoneyIcon from '@/components/tag.svg'
import UpdateIcon from '@/components/update.svg'
import ThirdPartyIcon from '@/components/third-party.svg'
import EnterIcon from '@/components/enter.svg'
import Link from 'next/link'
import Counter from './Counter'
import SupplierSemRushTraffic from './SupplierStats'
import { addProtocol } from './Util'
import { AuthorizedAccess } from './authorizedAccess'



export default function SupplierCard({supplier, editable, linkable, usages, latest = true, id, showCategories = true, showSemRushTraffic = true}) {

    return (
        <div id={id} className="list-card card relative">
            {supplier.thirdParty ? 
                <Image className='third-party' src={ThirdPartyIcon} width={42} height={42} alt="Third party icon" tooltip="Third party"/>
            : null}
            
            <Image src={Icon} width={32} height={32} alt="Shipping icon" className='inline-block'/>
            { ! latest ?
                <Image src={UpdateIcon} width={32} height={32} alt="Update icon" className='inline-block'/>
            : 
                null
            }
            {usages ?
                <Counter count={usages[supplier.id]} low={2} medium={5} high={25}/>
            : 
                null
            }
            {editable ?
                <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                    <Link href={"/supplier/"+supplier.id} rel='nofollow'>
                        <p id='supplier-editbtn-id' className='text-right float-right'>Edit</p>
                    </Link>
                </AuthorizedAccess>
            :
                null
            }
            <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                <div id={"supplier-name"} className={"text-xl my-2 "+(supplier.disabled?"text-gray-300":"")}>{supplier.name}</div>
            </AuthorizedAccess>
            
            <div className='grid grid-cols-12'>
                {linkable ?
                    <>
                        <Image className='col-span-1 inline-block ' src={LinkIcon} alt="link" width={20} height={20}/>
                        <Link href={addProtocol(supplier.website)} className='col-span-11' target='_blank' rel='nofollow'>
                            <span className='align-middle truncate'>{supplier.website}</span>
                        </Link>
                        <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                            <Image className='col-span-1 ' src={EmailIcon} alt="email" width={20} height={20}/>
                                <Link href={"mailto:"+supplier.email} className='col-span-11' rel='nofollow'>
                                <span id='supplier-email' className='align-middle truncate'>{supplier.email}</span>
                            </Link>
                        </AuthorizedAccess>
                    </>
                :
                    <>
                        <Image className='col-span-1 ' src={LinkIcon} alt="link" width={20} height={20}/>
                        <span className='col-span-11 align-middle truncate'>{supplier.website}</span>
                        <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                            <Image className='col-span-1 ' src={EmailIcon} alt="email" width={20} height={20}/>
                            <span id='supplier-email' className='col-span-11 align-middle truncate'>{supplier.email}</span>
                        </AuthorizedAccess>
                    </>
                }
                <Image className='col-span-1 ' src={DaIcon} alt="da" width={20} height="auto"/>
                <span id='supplier-da' className='col-span-11 align-middle text-lg font-bold'>{supplier.da}</span>
                
                <Image className='col-span-1' src={MoneyIcon} alt="money" width={25} height="auto"/> 
                <span id='supplier-fee' className='col-span-11 align-middle'>{supplier.weWriteFeeCurrency}{supplier.weWriteFee}</span>

                <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                    <Image className='col-span-1' src={EnterIcon} alt="money" width={30} height="auto"/>
                    <span id="supplier-source" className='col-span-11 align-middle'>{supplier.source}</span>
                </AuthorizedAccess>

            </div>
            
            {showCategories ?
                <CategoriesCard categories={supplier.categories}/>
            : 
                null
            }

            {showSemRushTraffic ?
                <SupplierSemRushTraffic supplier={supplier}/>
            : 
                null
            }
        </div>
    )
}