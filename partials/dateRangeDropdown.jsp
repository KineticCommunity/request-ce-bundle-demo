<div data-range class="header__date-range">
    <label> Date Range:
        <select data-date-range="${tableId}">
            <option value="1 Year">1 Year</option>
            <option value="View All">View All</option>
            <option value="Custom">Custom</option>
        </select>
    </label>
    <span data-section-date-range="${tableId}" class="hidden">
        <div data-date-picker-start="${tableId}" class="input-group">
            <input data-date-picker-start-input="${tableId}" type="text" class="form-control" aria-describedby="basic-addon2">
            <span class="input-group-addon" id="basic-addon2"><i class="fa fa-calendar"></i></span>
        </div>
        <div data-date-picker-end="${tableId}" class="input-group">
            <input data-date-picker-end-input="${tableId}" type="text" class="form-control" aria-describedby="basic-addon2">
            <span class="input-group-addon" id="basic-addon2"><i class="fa fa-calendar"></i></span>
        </div>
    </span>
</div>