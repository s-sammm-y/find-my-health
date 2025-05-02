import { TrendingUp } from "lucide-react";
import { Area, AreaChart, CartesianGrid, XAxis, Tooltip } from "recharts";
import axios from "axios";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "../ui/card";

import {
  ChartContainer,
  ChartTooltip,
  ChartTooltipContent,
} from "../ui/chart";
import { useEffect, useState } from "react";

// Chart data
const chartData = [
  { month: "January", desktop: 186, mobile: 80, other: 45 },
  { month: "February", desktop: 305, mobile: 200, other: 100 },
  { month: "March", desktop: 237, mobile: 120, other: 150 },
  { month: "April", desktop: 73, mobile: 190, other: 50 },
  { month: "May", desktop: 209, mobile: 130, other: 100 },
  { month: "June", desktop: 214, mobile: 140, other: 160 },
];

// Chart config
const chartConfig = {
  desktop: {
    label: "Desktop",
    color: "red",
  },
  mobile: {
    label: "Mobile",
    color: "blue",
  },
  other: {
    label: "Other",
    color: "green",
  },
};

function AnalyticsChart() {
  const [chartData, setChartData] = useState([]);
  const [chartConfig, setChartConfig] = useState({});

  useEffect(() => {
    const fetchSales = async () => {
      try {
        const response = await axios.get("http://localhost:3003/get_sales");
        const salesData = response.data.data;
  
        const monthlyDataMap = {};
  
        salesData.forEach((entry) => {
          const date = new Date(entry.sale_month);
          const month = date.toLocaleString("default", { month: "long" });
  
          if (!monthlyDataMap[month]) {
            monthlyDataMap[month] = { month, inventory: 0, med_category: 0 };
          }
  
          if (entry.item_type === "inventory") {
            monthlyDataMap[month].inventory += entry.total_sales;
          } else if (entry.item_type === "medicine") {
            monthlyDataMap[month].med_category += entry.total_sales;
          }
        });
  
        const chartDataArray = Object.values(monthlyDataMap);
  
        //Update chart data and config
        setChartData(chartDataArray);
        setChartConfig({
          inventory: {
            label: "Inventory Items",
            color: "red",
          },
          med_category: {
            label: "Medical Supplies",
            color: "blue",
          },
        });
  
      } catch (error) {
        console.log("Error fetching sales data", error);
      }
    };
  
    fetchSales();
  }, []);
  

  return (
    <Card>
      <CardHeader>
        <CardTitle>Area Chart - Stacked Expanded</CardTitle>
        <CardDescription>
          Showing inventory vs Medical_Supplies for last 6 months
        </CardDescription>
      </CardHeader>
      <CardContent>
        <ChartContainer config={chartConfig} className="w-[60vh] h-[40vh]">
          <AreaChart
            data={chartData}
            margin={{ left: 12, right: 12, top: 12 }}
            stackOffset="expand"
          >
            <CartesianGrid vertical={false} />
            <XAxis
              dataKey="month"
              tickLine={false}
              axisLine={false}
              tickMargin={8}
              tickFormatter={(value) => value.slice(0, 3)}
            />
            <ChartTooltip
              cursor={false}
              content={<ChartTooltipContent indicator="line" />}
            />
            <Area
              dataKey="inventory"
              type="natural"
              fill="var(--color-inventory)"
              fillOpacity={0.4}
              stroke="var(--color-inventory)"
              stackId="a"
            />
            <Area
              dataKey="med_category"
              type="natural"
              fill="var(--color-med_category)"
              fillOpacity={0.4}
              stroke="var(--color-med_category)"
              stackId="a"
            />
          </AreaChart>
        </ChartContainer>
      </CardContent>
      <CardFooter>
        <div className="flex w-full items-start gap-2 text-sm">
          <div className="grid gap-2">
            <div className="flex items-center gap-2 font-medium leading-none">
              Trending up by 5.2% this month <TrendingUp className="h-4 w-4" />
            </div>
            <div className="flex items-center gap-2 leading-none text-muted-foreground">
              January - May 2024
            </div>
          </div>
        </div>
      </CardFooter>
    </Card>
  );
}


export default AnalyticsChart;
