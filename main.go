package main

import (
	"flag"
	"fmt"
	"github.com/go-bls"
	"sort"
	"time"
)

func perror(err error) {
	if err != nil {
		panic(err)
	}
}

func min(i, j int) int {
	// the math package doesn't support ints?
	if i < j {
		return i
	} else {
		return j
	}
}

func aggregate_all_years(series string, start_year, end_year int) *bls.TimeSeriesResults {
	// BLS only allows 10 years per query. Query for each interval and squoosh
	// the results into one struct.
	// Pre: start_year < end_year
	data := new(bls.TimeSeriesResults)
	for left_bound := start_year; left_bound < end_year; left_bound += 10 {
		right_bound := min(left_bound+10, end_year)
		params := bls.TimeSeriesParams{[]string{series}, left_bound, right_bound}
		response := query(params)
		if len((*data).Series) == 0 {
			(*data).Series = response.Series
		} else {
			(*data).Series[0].Data = append((*data).Series[0].Data, response.Series[0].Data...)
		}
	}
	sort.Sort((*data).Series[0].Data)
	return data
}

func query(params bls.TimeSeriesParams) bls.TimeSeriesResults {
	// TODO(cs): shouldn't the go-bls library return a reference to a
	// TimeSeriesResults, not the value?
	data, err := bls.GetSeries(params)
	perror(err)

	if len(data.Message) > 0 {
		for _, message := range data.Message {
			fmt.Printf("Error: %s\n", message)
		}
		panic("There were problems with your query")
	}
	return data.Results
}

func main() {
	// -- Series format --
	// prefix: CE (National employment stats)
	// Seasonal Adjustment Code: S (Seasonal)
	// Industry code: 50 (Information)
	// Subfield code: 000000 (wildcard)
	// data_type: 01 (total employees, in thousands)
	// 'CES5000000001', 'CES4142343001'
	series_label := flag.String("series", "CES5000000001", "BLS series to query. See http://www.bls.gov/help/hlpforma.htm#CE")
	start_year := flag.Int("start_year", 1960, "Start year")
	end_year := flag.Int("end_year", 2014, "End year")
	flag.Parse()

	if *start_year >= *end_year {
		panic("Start year must come before end year")
	}

	aggregated := aggregate_all_years(*series_label, *start_year, *end_year)

	for _, series := range (*aggregated).Series {
		for _, data := range series.Data {
			t, _ := time.Parse("January", data.PeriodName)
			fmt.Printf("%s%02d %s\n", data.Year, t.Month(), data.Value)
		}
	}
}
