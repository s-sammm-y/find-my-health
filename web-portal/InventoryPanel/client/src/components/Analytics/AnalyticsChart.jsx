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
    const fetchInventory = async () => {
      try {
        const response = await axios.get("http://localhost:3003/analytics_chart");

        const { inventory, med_category } = response.data.data;

        console.log("Fetched inventory and med_category", inventory, med_category);
        
        // For now: just generate random counts for each month
        const months = ["January", "February", "March", "April", "May", "June"];
        const generatedChartData = months.map((month) => ({
          month,
          inventory: Math.floor(Math.random() * 100),
          med_category: Math.floor(Math.random() * 100),
        }));

        setChartData(generatedChartData);

        // Configure colors for inventory and med_category
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
      } catch (err) {
        console.log("Error fetching inventory in frontend", err);
      }
    };

    fetchInventory();
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
              January - June 2024
            </div>
          </div>
        </div>
      </CardFooter>
    </Card>
  );
}


export default AnalyticsChart;
