import Image from 'next/image'
import Icon from '@/components/logo.png'

export default function FooterPublic() {
    return (
        <footer className="bg-white rounded-lg shadow dark:bg-gray-900 m-4">
            <div className="w-full max-w-screen-xl mx-auto p-4 md:py-8">
                <div className="sm:flex sm:items-center sm:justify-between">
                    <a href="https://slinkylinky.uk/" className="flex items-center mb-4 sm:mb-0 space-x-3 rtl:space-x-reverse">
                        <Image src={Icon} width={439/6} height={498/6} alt="Logo" className="p-1 inline-block"/>
                        <span className="self-center text-2xl font-semibold whitespace-nowrap dark:text-white">Slinky Linky</span>
                    </a>
                    
                </div>
                <hr className="my-6 border-gray-200 sm:mx-auto dark:border-gray-700 lg:my-8" />
                <span className="block text-sm text-gray-500 sm:text-center dark:text-gray-400">© 2023 <a href="https://slinkylinky.uk/" className="hover:underline">Slinky Linky™</a>. All Rights Reserved.</span>
            </div>
        </footer>
    );
}