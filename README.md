You will need to clone https://github.com/colin-scott/go-bls and run `go install github.com/colin-scott/go-bls`. I may have cut off the colin-scott prefix, fwiw.

For NES data, run, `go build`, and `./bls -series <SERIES> > cs.dat`, and `gnuplot nes.gpi`

For OES data, chdir to data/ and see the README there, then run `gnuplot oes.gpi`

BLS series of interest:

Monthly (fairly coarse granularity):

Trade:
CES41423430 Computer and software trade (salespeople?)

Information:
CES50000000 "Information industry" (including media)
CES50511200 Software Publishers
CES50518000 Data processing, hosting and related services
CES50519130 Internet publishing and broadcasting and web search portals

Service:
CES60541500 Computer systems design and related services
CES60541511 Custom computer programming services
CES60541512 Computer systems design services
CES60541700 Scientific research and development services (Non-academic??)

Manufacturing:
CES31334000  Computer and electronic products
CES31334100  Computer and peripheral equipment
CES31334111  Electronic computers
CES31334112  Computer storage devices 
CES31334118  Computer terminals and other computer peripheral equipment
CES31334200  Communications equipment

Education:
CES65611300 Colleges and universities
CES65611500 Technical and trade schools

Yearly (finer granularity, but only dates to 1988):

OEUN00000000000000XXXXXX1

Education:
251021 Computer Science Teachers and Researchers, PostSecondary
251191 Graduate Teaching Assistants
151111 Computer and Information Research Scientists (Industry)

Industry:
113021  Computer and Information Systems Managers
150000  Computer and Mathematical Occupations
151100  Computer Occupations
151120  Computer and Information Analysts
151121  Computer Systems Analysts
151122  Information Security Analysts
151130  Software Developers and Programmers
151131  Computer Programmers
151132  Software Developers, Applications
151133  Software Developers, Systems Software
151134  Web Developers
151140  Database and Systems Administrators and Network Architects
151141  Database Administrators
151142  Network and Computer Systems Administrators
151143  Computer Network Architects
151150  Computer Support Specialists
151151  Computer User Support Specialists
151152  Computer Network Support Specialists
151199  Computer Occupations, All Other

Hardware:
172061  Computer Hardware Engineers
172070  Electrical and Electronics Engineers
172071  Electrical Engineers

