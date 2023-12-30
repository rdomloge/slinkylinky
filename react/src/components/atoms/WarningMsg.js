import Image from 'next/image'
import Icon from '@/components/warning.svg'

export default function WarningMessage({message}) {
    return (
        <div className="align-middle p-2 m-2">
            <Image src={Icon} width={32} height={32} alt="Warning icon" className='inline-block align-middle mr-2'/>
            <p className='inline-block text-red-500 text-2xl align-middle'>{message}</p>
        </div>
    );
}