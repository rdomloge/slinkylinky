import Image from 'next/image'
import WarningIcon from '@/components/warning.svg'
import InfoIcon from '@/components/info.svg'
import SuccessIcon from '@/components/success.svg'
import ErrorIcon from '@/components/stop-sign.svg'

export default function ErrorMessage({message, iconWidth=32, iconHeight=32, id, iconClass='flex-initial inline-block align-middle mr-2', messageClass='inline-block text-red-700 align-middle'}) {
    return (
        <div className={"align-middle p-2 m-2 bg-red-200 border border-red-700 rounded p-1 flex "+(message?"":"hidden")}>
            <Image src={ErrorIcon} width={iconWidth} height={iconHeight} alt="Warning icon" className={iconClass}/>
            <p className={messageClass} id={id}>{message}</p>
        </div>
    );
}

export function SuccessMessage({message, iconWidth=32, iconHeight=32, iconClass='flex-initial inline-block align-middle mr-2', messageClass='inline-block text-green-700 align-middle'}) {
    return (
        <div className={"align-middle p-2 m-2 bg-green-200 border border-green-700 rounded p-1 flex "+(message?"":"hidden")}>
            <Image src={SuccessIcon} width={iconWidth} height={iconHeight} alt="Warning icon" className={iconClass}/>
            <p className={messageClass}>{message}</p>
        </div>
    );
}

export function InfoMessage({message, iconWidth=32, iconHeight=32, iconClass='flex-initial inline-block align-middle mr-2', messageClass='inline-block text-blue-700 align-middle'}) {
    return (
        <div className={"align-middle p-2 m-2 bg-blue-200 border border-blue-700 rounded p-1 flex "+(message?"":"hidden")}>
            <Image src={InfoIcon} width={iconWidth} height={iconHeight} alt="Warning icon" className={iconClass}/>
            <p className={messageClass}>{message}</p>
        </div>
    );
}

export function WarningMessage({message, iconWidth=32, iconHeight=32, iconClass='flex-initial inline-block align-middle mr-2', messageClass='inline-block text-yellow-700 align-middle'}) {
    return (
        <div className={"align-middle p-2 m-2 bg-yellow-200 border border-yellow-700 rounded p-1 flex "+(message?"":"hidden")}>
            <Image src={WarningIcon} width={iconWidth} height={iconHeight} alt="Warning icon" className={iconClass}/>
            <p className={messageClass}>{message}</p>
        </div>
    );
}