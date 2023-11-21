import LinkDemand from './linkdemand/LinkDemand'
import PageTitle from '@/components/pagetitle'

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col justify-between p-10">
      <PageTitle title="Demand"/>
      <div className="z-10 max-w-5xl w-full items-center justify-between font-mono text-sm lg:flex">
        <LinkDemand/>
      </div>
    </main>
  )
}
