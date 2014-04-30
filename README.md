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

Yearly (finer granularity, but only dates to 1988) documented in data/
