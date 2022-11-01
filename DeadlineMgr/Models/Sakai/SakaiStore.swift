//
//  SakaiStore.swift
//  deadline_manager
//
//  Created by Tianjun Mo on 2022/10/18.
//

import Foundation

class SakaiStore: ObservableObject {
    static let shared: SakaiStore = .init()
    @Published var cookies: [String: String] = [:]
    @Published var sites: [SakaiSite] = [] { didSet {
        Task {
            let newEvents = await withTaskGroup(of: (SakaiSite, [SakaiEvent]).self, body: { group in
                var newEvents = events
                for site in sites {
                    if newEvents[site] != nil {
                        continue
                    }
                    group.addTask {
                        let events = await self.genEventsBySite(site_id: site.id)
                        return (site, events)
                    }
                }

                for await (site, events) in group {
                    newEvents[site] = events
                }
                return newEvents
            })
            DispatchQueue.main.async {
                self.events = newEvents
            }
        }

    }}

    var cookieStr: String {
        cookies.map { key, value in "\(key)=\(value);" }
            .joined(separator: " ")
    }

    @Published var events: [SakaiSite: [SakaiEvent]] = [:]
    @Published var user: SakaiUser? = nil

    var isAuth: Bool {
        cookies.count != 0
    }

    private init() {
        loadCookies()
        fetchInfo()
    }

    private enum SakaiAPIEndpoint: String {
        case SITES = "https://sakai.duke.edu/direct/site.json"
        case ASSIGNMENTS = "https://sakai.duke.edu/direct/assignment/site/%@.json"
        case USER = "https://sakai.duke.edu/direct/user/current.json"
    }

    private func getUrl(_ endpoint: SakaiAPIEndpoint, _ args: CVarArg...) -> String {
        return String(format: endpoint.rawValue, args)
    }

    private func request(_ endpoint: SakaiAPIEndpoint,
                         _ method: Server.Method,
                         _ args: CVarArg...) async -> (Data?, HTTPURLResponse?, Error?)
    {
        let url = getUrl(endpoint, args)
        let headers = ["cookie": cookieStr]
        return await Server.request(url, method, headers)
    }

    func genUser() async -> SakaiUser? {
        if !isAuth {
            return nil
        }
        let (data, _, _) = await request(.USER, .GET)
        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
        if (json["id"] as! String) == "" {
            return nil
        }
        return SakaiUser(
            id: json["id"] as! String,
            name: json["displayName"] as! String,
            email: json["email"] as! String)
    }

    func genAllSites() async -> [SakaiSite]? {
        if !isAuth {
            return nil
        }
        let (data, _, _) = await request(.SITES, .GET)
        // parse data into a dictionary
        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
        let sites = json["site_collection"] as! [[String: Any]]
        return sites.map { site in
            SakaiSite(
                id: site["id"] as! String,
                title: site["title"] as! String)
        }
    }

    func genEventsBySite(site_id: String) async -> [SakaiEvent] {
        let (data, _, _) = await request(.ASSIGNMENTS, .GET, site_id)
        let dateFormatter = ISO8601DateFormatter()
        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
        let assignments = json["assignment_collection"] as! [[String: Any]]
        return assignments.map { asm in
            SakaiEvent(
                id: asm["id"] as! String,
                title: asm["title"] as! String,
                url: asm["entityURL"] as! String,
                dueDate: dateFormatter.date(from: asm["dueTimeString"] as! String)!,
                openDate: dateFormatter.date(from: asm["openTimeString"] as! String)!)
        }
    }

    // save cookies to user defaults
    func saveCookies() {
        let defaults = UserDefaults.standard
        defaults.set(cookies, forKey: "cookies")
    }

    func loadCookies() {
        let defaults = UserDefaults.standard
        cookies = defaults.object(forKey: "cookies") as? [String: String] ?? [:]
    }

    func fetchInfo() {
        if !isAuth {
            print("not auth yet")
            return
        }
        DispatchQueue.main.async {
            Task {
                self.events = [:]
                self.user = await self.genUser()
                self.sites = await self.genAllSites() ?? []
            }
        }
    }
}
