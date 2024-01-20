# 符合条件的两个相邻(t_diff <= 5) seasons, 合并endtime
# `rigth` merged into `left`
function RightCombine_season(y_peak, y_end, date_peak, date_end, i::Integer)
  y_end[i] = y_end[i+1]
  date_end[i] = date_end[i+1]
  # len[i] = date_end[i] - date_beg[i] + 1;

  if (y_peak[i] < y_peak[i+1])
    date_peak[i] = date_peak[i+1]
    y_peak[i] = y_peak[i+1]
  end
  y_peak[i+1] = -9999.0 ## flag
end

# 处理相邻的peaks，进行融合操作
# 1. 第二周期，左侧trough过高，超过`0.7*A` (BUG found)
# 2. 第二周期，左侧r_min过小, （其ypeak > r_min + 0.1）
# 3. 第一周期，右侧r_min过小,
# 3. (not used) 如果相邻生长季返青日期过短，则执行合并操作
# 这里用max，而非min，意在保护A较小的生长季

mutable struct st_season
  di
  r_max::Float64
  r_min::Float64
  # y_max::Float64
  # y_min::Float64
end

# 如下情景会触发融合
# - 1. y_end[i] >= A * rtrough_max + T1_minVal
# - 2. con_left
# - 3. con_right
function check_season!(d; r_max=0.1, r_min=0.02, rtrough_max=0.7)
  # t_diff <= DAYS_maxDIFF; # 相差在`DAYS_maxDIFF`天内认为相邻
  DAYS_maxDIFF = 50    # days
  DAYS_max2GS = 650    # days, max length of two growing seasons being able to merge

  # TODO: add a while for loop
  date_beg = d[!, 1]
  date_peak = d[!, 2]
  date_end = d[!, 3]
  y_beg = d[!, 4]
  y_peak = d[!, 5]
  y_end = d[!, 6]
  # len     = d[!, "len"];

  ## 现已考虑的情景包含如下：
  # 1. growing season日期交差                                  : t_diff < 0
  # 2. 两相邻val_troughs挨得太近（且中间不存在较大的peaks）    : t_diff <= 50
  # 3(temp). 两相邻val_troughs值相差过大; 且不重叠，则进行融合
  n = length(date_beg)
  for i = 1:n-1
    if y_peak[i] == 9999.0 || y_peak[i+1] == 9999.0
      continue
    end

    t_diff = date_beg[i+1] - date_end[i] # 滞后时间，生长周期空窗期
    T2s = date_end[i+1] - date_beg[i] # 两个生长周期长度

    T1_minVal = min(y_beg[i], y_end[i])
    T2_minVal = min(y_beg[i+1], y_end[i+1])
    maxY = max(y_peak[i], y_peak[i+1])
    minY = min(T1_minVal, T2_minVal)
    A = maxY - minY

    T1_h_right = y_peak[i] - y_end[i]         # T1, height of the right hand
    T2_h_left = y_peak[i+1] - y_beg[i+1] # T2, height of left hand

    trs = A * r_min
    trs_max = A * r_max
    # # 1. y_end[i] >= trs || y_beg[i+1] >= trs 定义为高trough
    # #  diff =  abs(y_end[i] - y_beg[i+1]);
    # # bool is_HighTrough = y_end[i] >= trs || y_beg[i+1] >= trs;
    is_PreEndSmaller = (y_end[i] <= y_beg[i+1]) # previous y_end smaller ?

    # 如果两日期出现交叉，则重新洗牌`y_end[i]` and `y_beg[i+1]`
    if (t_diff < 0) ##|| (is_HighTrough && delta_days < 0)
      # TODO: 补充出现这种情况的情景
      newdate = is_PreEndSmaller ? date_end[i] : date_beg[i+1]
      newval = is_PreEndSmaller ? y_end[i] : y_beg[i+1]

      date_end[i] = newdate
      date_beg[i+1] = newdate
      y_end[i] = newval
      y_beg[i+1] = newval
    end

    is_closed = t_diff >= 0 && t_diff <= DAYS_maxDIFF ## 相差在5天内认为相邻
    # diff_right = y_peak[i + 1] - y_end[i + 1];
    # Rprintf("T1_h_right = %#4.2f, T2_h_left = % 4.2f, trs = %4.2f\n", T1_h_right, T2_h_left, trs);
    # a. 向左移动：如果T1_h_right过小，T1_h_left够大
    # b. 向右移动：如果T2_h_left过小，T2_h_right够大
    con_left = (T1_h_right <= trs && y_beg[i] < y_beg[i+1] && (y_peak[i] - T1_minVal > trs_max))
    con_right = (T2_h_left <= trs && y_end[i] > y_end[i+1] && (y_peak[i+1] - T1_minVal > trs_max))

    if (is_closed && T2s <= DAYS_max2GS &&
        ((y_end[i] >= A * rtrough_max + T1_minVal) || con_right || con_left))
      RightCombine_season(y_peak, y_end, date_peak, date_end, i)
      d[i, :status] = ""
      i += 1 # 如果进行了融合，则跳过下一生长周期
      continue
    end
    # if (is_closed && con_left)
    #     LeftCombine_season(y_peak, y_end, len, , date_peak, date_end, i);
    #     i++; # 如果进行了融合，则跳过下一生长周期
    #     continue;
    # end
  end
  # st_season(d, r_max, r_min) #, y_max, y_min
  d |> update_seasons
  # d[y_peak .> 9999.0]
end

# update diff_max, and diff_min
# only update season
function update_seasons(d)
  missval = -9999.0
  ind = (d[!, 5] .<= missval) # peak

  d[!, :diff_max] = max.(d[:, 5] - d[:, 4], d[:, 5] - d[:, 6])
  d[!, :diff_min] = min.(d[:, 5] - d[:, 4], d[:, 5] - d[:, 6])

  if length(ind) > 0
    d[ind, :diff_max] .= missval
    d[ind, :diff_min] .= missval
  end
  d
end

export check_season!

## 坡脚修复大法的功能已经在`seasons_union`中得到了体现
## IT-BCi, ending of 2005; 必须是相邻troughs
# if (t_diff > 0 && t_diff <= 150 &&
#     T2_h_left <= trs && y_end[i] < y_beg[i + 1]) # 
#     if (verbose); println("date_beg: from $(date_beg[i]) to $(date_beg[i+1])"); end
#     # ? 为何添加 `y_end[i] < y_beg[i + 1]`的限制条件？
#     # 向左拱进
#     y_beg[i + 1] = y_beg[i];
#     date_beg[i + 1] = date_beg[i];
#     # # len[i + 1] = date_end[i + 1] - date_beg[i + 1] + 1;
# end
