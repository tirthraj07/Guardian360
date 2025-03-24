import Link from "next/link"
import { Home, FileText, ChartBarIcon } from "lucide-react"

export function Sidebar() {
  return (
    <div className="w-64 bg-black shadow-md">
      <div className="p-4">
        <h1 className="text-xl font-bold">Police Station Platform</h1>
      </div>
      <nav className="mt-4">
        <Link href="/" className="flex items-center px-4 py-2 text-gray-400 hover:bg-gray-100">
          <Home className="mr-2" size={20} />
          Dashboard
        </Link>
        <Link href="/cases" className="flex items-center px-4 py-2 text-gray-400 hover:bg-gray-100">
          <FileText className="mr-2" size={20} />
          Cases
        </Link>
        <Link href="/analytics" className="flex items-center px-4 py-2 text-gray-400 hover:bg-gray-100">
          <ChartBarIcon className="mr-2" size={20} />
          Analytics
        </Link>
      </nav>
    </div>
  )
}

