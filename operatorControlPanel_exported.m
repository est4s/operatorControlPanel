classdef operatorControlPanel_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        TabGroup                        matlab.ui.container.TabGroup
        mainTab                         matlab.ui.container.Tab
        GridLayout                      matlab.ui.container.GridLayout
        MaterialEditField               matlab.ui.control.EditField
        MaterialEditFieldLabel          matlab.ui.control.Label
        ThicknessmmEditField            matlab.ui.control.NumericEditField
        ThicknessmmEditFieldLabel       matlab.ui.control.Label
        LengthmmEditField               matlab.ui.control.NumericEditField
        LengthmmEditFieldLabel          matlab.ui.control.Label
        RackAngledegreeEditField        matlab.ui.control.NumericEditField
        RackAngledegreeEditFieldLabel   matlab.ui.control.Label
        ClampingPressurebarEditField_2  matlab.ui.control.NumericEditField
        ClampingPressurebarEditField_2Label  matlab.ui.control.Label
        CalculateButton                 matlab.ui.control.Button
        StrokemmEditField_2Label        matlab.ui.control.Label
        StrokemmEditField_2             matlab.ui.control.NumericEditField
        materialTab                     matlab.ui.container.Tab
        GridLayout2                     matlab.ui.container.GridLayout
        MaterialsListBox                matlab.ui.control.ListBox
        MaterialsListBoxLabel           matlab.ui.control.Label
        lengthandthicknessTab           matlab.ui.container.Tab
        GridLayout3                     matlab.ui.container.GridLayout
        LengthmmEditField_2Label        matlab.ui.control.Label
        LengthmmEditField_2             matlab.ui.control.NumericEditField
        ThicknessmmEditField_2Label     matlab.ui.control.Label
        ThicknessmmEditField_2          matlab.ui.control.NumericEditField
        RackAngledegreeEditField_2Label  matlab.ui.control.Label
        RackAngledegreeEditField_2      matlab.ui.control.NumericEditField
        ClearancemmEditFieldLabel       matlab.ui.control.Label
        ClearancemmEditField            matlab.ui.control.NumericEditField
        hydraulicTab                    matlab.ui.container.Tab
        GridLayout4                     matlab.ui.container.GridLayout
        ClampingPressurebarEditFieldLabel  matlab.ui.control.Label
        ClampingPressurebarEditField    matlab.ui.control.NumericEditField
        StrokemmEditFieldLabel          matlab.ui.control.Label
        StrokemmEditField               matlab.ui.control.NumericEditField
        otherTab                        matlab.ui.container.Tab
        GridLayout5                     matlab.ui.container.GridLayout
        EccentricShaftAngleEditFieldLabel  matlab.ui.control.Label
        EccentricShaftAngleEditField    matlab.ui.control.NumericEditField
        CuttingForcekNEditFieldLabel    matlab.ui.control.Label
        CuttingForcekNEditField         matlab.ui.control.NumericEditField
        ClampingForcekNEditFieldLabel   matlab.ui.control.Label
        ClampingForcekNEditField        matlab.ui.control.NumericEditField
        PositionSensorDifferencemmEditFieldLabel  matlab.ui.control.Label
        PositionSensorDifferencemmEditField  matlab.ui.control.NumericEditField
        proportionalValveTab            matlab.ui.container.Tab
        GridLayout6                     matlab.ui.container.GridLayout
        LeftValveGauge                  matlab.ui.control.NinetyDegreeGauge
        LeftValveGaugeLabel             matlab.ui.control.Label
        RightValveGauge                 matlab.ui.control.NinetyDegreeGauge
        RightValveGaugeLabel            matlab.ui.control.Label
        PositionDifferenceSliderLabel   matlab.ui.control.Label
        PositionDifferenceSlider        matlab.ui.control.Slider
    end

    
    properties (Access = public)
        currentThickness=.5;
        clampingP=0;
        clampingF=0;
        cuttingF=0;
        clampingA=pi*40^2/4;
        %angleU=repelem(deg2rad([0.5 1 1.5 2]), 24);
        %currentAngle=deg2rad(0.5);
        stroke=0;
        cuttingLength=0;
        posDif=0;
        rValve=100;
        lValve=100;
        
        materials={'AL1050-HX4' 'AL3003-HX4' 'AL5754-HX4' 'ST33' 'ST37' 'ST44' 'AISI201' 'AISI304' 'AISI316'};
        materialUts=[110 150 250 350 370 450 750 550 600];
        currentUts=185;
        clearanceAllowance=repelem([0.045 0.060 0.075], 3);
        currentClearanceAllowance=0.075;
        
        
        positionDifference=0;
        
        angleU=0.5:0.1:2;
        radAngle=0;
        currentAngle=0;
        theForce=0;
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: MaterialsListBox
        function MaterialsListBoxValueChanged(app, event)
            value = app.MaterialsListBox.Value;
            app.MaterialEditField.Value=value;
            for i= 1:1:length(app.materials)
                if strcmp(app.materials(i), value)
                    app.currentUts=app.materialUts(i);
                    app.currentClearanceAllowance=app.clearanceAllowance(i);
                end
            end
        end

        % Value changed function: ThicknessmmEditField_2
        function ThicknessmmEditField_2ValueChanged(app, event)
            value = app.ThicknessmmEditField_2.Value;
            app.currentThickness=value;
        end

        % Value changed function: LengthmmEditField_2
        function LengthmmEditField_2ValueChanged(app, event)
            value = app.LengthmmEditField_2.Value;
            app.cuttingLength=value;
        end

        % Button pushed function: CalculateButton
        function CalculateButtonPushed(app, event)
%             m=app.currentThickness*cot(app.currentAngle);
%             area1=(m*app.currentThickness)/2;
%             app.cuttingF=app.currentUts*0.7*area1*1.5;
%             app.clampingF=app.cuttingF/5;
            app.radAngle=deg2rad(app.angleU);
            for i=1:1:16
                l=app.currentThickness*cot(app.radAngle(i));
                area=(l*app.currentThickness)/2;
                cForce=1.5*0.7*app.currentUts*area;
                if cForce<=680000
                    app.theForce=cForce;
                    app.currentAngle=app.angleU(i);
                    break;
                end
                if i==16
                    disp('cannot cut');
                    warndlg('This material can not be cut for entered thickness.','Warning');
                end
            %disp(i);
            %disp(angle(i));
            end
            
            app.CuttingForcekNEditField.Value=app.theForce;
            app.clampingF=app.theForce/5;
            app.clampingP=app.clampingF/app.clampingA;
            app.ClampingPressurebarEditField.Value=app.clampingP;
            
            app.stroke=app.cuttingLength*tan(app.radAngle(i))+app.currentThickness+50;
            app.StrokemmEditField.Value=app.stroke;
            
            app.RackAngledegreeEditField_2.Value=app.currentAngle;
            
            app.ClearancemmEditField.Value=app.currentClearanceAllowance*app.currentThickness;
            
            app.EccentricShaftAngleEditField.Value=rad2deg(acos(-(9996-(102-app.currentClearanceAllowance*app.currentThickness)^2)/(4*(102-app.currentClearanceAllowance*app.currentThickness))));
            
            app.ThicknessmmEditField.Value=app.currentThickness;
            app.LengthmmEditField.Value=app.cuttingLength;
            app.RackAngledegreeEditField.Value=app.RackAngledegreeEditField_2.Value;
            app.ClampingPressurebarEditField_2.Value=app.ClampingPressurebarEditField.Value;
            app.StrokemmEditField_2.Value=app.stroke;
            app.ClampingForcekNEditField.Value=app.clampingF;
            app.positionDifference=2032*sin(app.radAngle(i));
            app.PositionSensorDifferencemmEditField.Value=app.positionDifference;
            
            disp(app.currentUts);
            disp(app.cuttingF);
            
            
        end

        % Value changing function: PositionDifferenceSlider
        function PositionDifferenceSliderValueChanging(app, event)
            changingValue = event.Value;
            if changingValue>0
                app.RightValveGauge.Value=100-abs(changingValue)*20;
                app.LeftValveGauge.Value=100;
            elseif changingValue<0
                app.LeftValveGauge.Value=100-abs(changingValue)*20;
                app.RightValveGauge.Value=100;
            else
                app.RightValveGauge.Value=100;
                app.LeftValveGauge.Value=100;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 508 250];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 0 509 251];

            % Create mainTab
            app.mainTab = uitab(app.TabGroup);
            app.mainTab.Title = 'main';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.mainTab);
            app.GridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', 24};

            % Create MaterialEditField
            app.MaterialEditField = uieditfield(app.GridLayout, 'text');
            app.MaterialEditField.Editable = 'off';
            app.MaterialEditField.HorizontalAlignment = 'center';
            app.MaterialEditField.Layout.Row = 1;
            app.MaterialEditField.Layout.Column = 2;

            % Create MaterialEditFieldLabel
            app.MaterialEditFieldLabel = uilabel(app.GridLayout);
            app.MaterialEditFieldLabel.HorizontalAlignment = 'center';
            app.MaterialEditFieldLabel.Layout.Row = 1;
            app.MaterialEditFieldLabel.Layout.Column = 1;
            app.MaterialEditFieldLabel.Text = 'Material';

            % Create ThicknessmmEditField
            app.ThicknessmmEditField = uieditfield(app.GridLayout, 'numeric');
            app.ThicknessmmEditField.Editable = 'off';
            app.ThicknessmmEditField.HorizontalAlignment = 'center';
            app.ThicknessmmEditField.Layout.Row = 2;
            app.ThicknessmmEditField.Layout.Column = 2;

            % Create ThicknessmmEditFieldLabel
            app.ThicknessmmEditFieldLabel = uilabel(app.GridLayout);
            app.ThicknessmmEditFieldLabel.HorizontalAlignment = 'center';
            app.ThicknessmmEditFieldLabel.FontSize = 15;
            app.ThicknessmmEditFieldLabel.Layout.Row = 2;
            app.ThicknessmmEditFieldLabel.Layout.Column = 1;
            app.ThicknessmmEditFieldLabel.Text = 'Thickness (mm)';

            % Create LengthmmEditField
            app.LengthmmEditField = uieditfield(app.GridLayout, 'numeric');
            app.LengthmmEditField.Editable = 'off';
            app.LengthmmEditField.HorizontalAlignment = 'center';
            app.LengthmmEditField.Layout.Row = 3;
            app.LengthmmEditField.Layout.Column = 2;

            % Create LengthmmEditFieldLabel
            app.LengthmmEditFieldLabel = uilabel(app.GridLayout);
            app.LengthmmEditFieldLabel.HorizontalAlignment = 'center';
            app.LengthmmEditFieldLabel.FontSize = 15;
            app.LengthmmEditFieldLabel.Layout.Row = 3;
            app.LengthmmEditFieldLabel.Layout.Column = 1;
            app.LengthmmEditFieldLabel.Text = 'Length (mm)';

            % Create RackAngledegreeEditField
            app.RackAngledegreeEditField = uieditfield(app.GridLayout, 'numeric');
            app.RackAngledegreeEditField.Editable = 'off';
            app.RackAngledegreeEditField.HorizontalAlignment = 'center';
            app.RackAngledegreeEditField.Layout.Row = 4;
            app.RackAngledegreeEditField.Layout.Column = 2;

            % Create RackAngledegreeEditFieldLabel
            app.RackAngledegreeEditFieldLabel = uilabel(app.GridLayout);
            app.RackAngledegreeEditFieldLabel.HorizontalAlignment = 'center';
            app.RackAngledegreeEditFieldLabel.FontSize = 15;
            app.RackAngledegreeEditFieldLabel.Layout.Row = 4;
            app.RackAngledegreeEditFieldLabel.Layout.Column = 1;
            app.RackAngledegreeEditFieldLabel.Text = 'Rack Angle (degree)';

            % Create ClampingPressurebarEditField_2
            app.ClampingPressurebarEditField_2 = uieditfield(app.GridLayout, 'numeric');
            app.ClampingPressurebarEditField_2.Editable = 'off';
            app.ClampingPressurebarEditField_2.HorizontalAlignment = 'center';
            app.ClampingPressurebarEditField_2.Layout.Row = 5;
            app.ClampingPressurebarEditField_2.Layout.Column = 2;

            % Create ClampingPressurebarEditField_2Label
            app.ClampingPressurebarEditField_2Label = uilabel(app.GridLayout);
            app.ClampingPressurebarEditField_2Label.HorizontalAlignment = 'center';
            app.ClampingPressurebarEditField_2Label.FontSize = 15;
            app.ClampingPressurebarEditField_2Label.Layout.Row = 5;
            app.ClampingPressurebarEditField_2Label.Layout.Column = 1;
            app.ClampingPressurebarEditField_2Label.Text = 'Clamping Pressure (bar)';

            % Create CalculateButton
            app.CalculateButton = uibutton(app.GridLayout, 'push');
            app.CalculateButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateButtonPushed, true);
            app.CalculateButton.FontSize = 15;
            app.CalculateButton.Layout.Row = 7;
            app.CalculateButton.Layout.Column = 2;
            app.CalculateButton.Text = 'Calculate';

            % Create StrokemmEditField_2Label
            app.StrokemmEditField_2Label = uilabel(app.GridLayout);
            app.StrokemmEditField_2Label.HorizontalAlignment = 'center';
            app.StrokemmEditField_2Label.FontSize = 15;
            app.StrokemmEditField_2Label.Layout.Row = 6;
            app.StrokemmEditField_2Label.Layout.Column = 1;
            app.StrokemmEditField_2Label.Text = 'Stroke (mm)';

            % Create StrokemmEditField_2
            app.StrokemmEditField_2 = uieditfield(app.GridLayout, 'numeric');
            app.StrokemmEditField_2.Editable = 'off';
            app.StrokemmEditField_2.HorizontalAlignment = 'center';
            app.StrokemmEditField_2.Layout.Row = 6;
            app.StrokemmEditField_2.Layout.Column = 2;

            % Create materialTab
            app.materialTab = uitab(app.TabGroup);
            app.materialTab.Title = 'material';

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.materialTab);
            app.GridLayout2.RowHeight = {'1x', '1x', '1x', '1x'};

            % Create MaterialsListBox
            app.MaterialsListBox = uilistbox(app.GridLayout2);
            app.MaterialsListBox.Items = {'AL1050-HX4', 'AL3003-HX4', 'AL5754-HX4', 'ST33', 'ST37', 'ST44', 'AISI201', 'AISI304', 'AISI316'};
            app.MaterialsListBox.ValueChangedFcn = createCallbackFcn(app, @MaterialsListBoxValueChanged, true);
            app.MaterialsListBox.FontSize = 15;
            app.MaterialsListBox.Layout.Row = [1 4];
            app.MaterialsListBox.Layout.Column = 2;
            app.MaterialsListBox.Value = 'AL1050-HX4';

            % Create MaterialsListBoxLabel
            app.MaterialsListBoxLabel = uilabel(app.GridLayout2);
            app.MaterialsListBoxLabel.HorizontalAlignment = 'center';
            app.MaterialsListBoxLabel.FontSize = 15;
            app.MaterialsListBoxLabel.Layout.Row = [1 4];
            app.MaterialsListBoxLabel.Layout.Column = 1;
            app.MaterialsListBoxLabel.Text = 'Materials';

            % Create lengthandthicknessTab
            app.lengthandthicknessTab = uitab(app.TabGroup);
            app.lengthandthicknessTab.Title = 'length and thickness';

            % Create GridLayout3
            app.GridLayout3 = uigridlayout(app.lengthandthicknessTab);
            app.GridLayout3.RowHeight = {'1x', '1x', '1x', '1x'};

            % Create LengthmmEditField_2Label
            app.LengthmmEditField_2Label = uilabel(app.GridLayout3);
            app.LengthmmEditField_2Label.HorizontalAlignment = 'center';
            app.LengthmmEditField_2Label.FontSize = 15;
            app.LengthmmEditField_2Label.Layout.Row = 1;
            app.LengthmmEditField_2Label.Layout.Column = 1;
            app.LengthmmEditField_2Label.Text = 'Length (mm)';

            % Create LengthmmEditField_2
            app.LengthmmEditField_2 = uieditfield(app.GridLayout3, 'numeric');
            app.LengthmmEditField_2.Limits = [0 2000];
            app.LengthmmEditField_2.ValueChangedFcn = createCallbackFcn(app, @LengthmmEditField_2ValueChanged, true);
            app.LengthmmEditField_2.Layout.Row = 1;
            app.LengthmmEditField_2.Layout.Column = 2;

            % Create ThicknessmmEditField_2Label
            app.ThicknessmmEditField_2Label = uilabel(app.GridLayout3);
            app.ThicknessmmEditField_2Label.HorizontalAlignment = 'center';
            app.ThicknessmmEditField_2Label.FontSize = 15;
            app.ThicknessmmEditField_2Label.Layout.Row = 2;
            app.ThicknessmmEditField_2Label.Layout.Column = 1;
            app.ThicknessmmEditField_2Label.Text = 'Thickness (mm)';

            % Create ThicknessmmEditField_2
            app.ThicknessmmEditField_2 = uieditfield(app.GridLayout3, 'numeric');
            app.ThicknessmmEditField_2.Limits = [0 10];
            app.ThicknessmmEditField_2.ValueChangedFcn = createCallbackFcn(app, @ThicknessmmEditField_2ValueChanged, true);
            app.ThicknessmmEditField_2.Layout.Row = 2;
            app.ThicknessmmEditField_2.Layout.Column = 2;

            % Create RackAngledegreeEditField_2Label
            app.RackAngledegreeEditField_2Label = uilabel(app.GridLayout3);
            app.RackAngledegreeEditField_2Label.HorizontalAlignment = 'center';
            app.RackAngledegreeEditField_2Label.FontSize = 15;
            app.RackAngledegreeEditField_2Label.Layout.Row = 3;
            app.RackAngledegreeEditField_2Label.Layout.Column = 1;
            app.RackAngledegreeEditField_2Label.Text = 'Rack Angle (degree)';

            % Create RackAngledegreeEditField_2
            app.RackAngledegreeEditField_2 = uieditfield(app.GridLayout3, 'numeric');
            app.RackAngledegreeEditField_2.Editable = 'off';
            app.RackAngledegreeEditField_2.Layout.Row = 3;
            app.RackAngledegreeEditField_2.Layout.Column = 2;

            % Create ClearancemmEditFieldLabel
            app.ClearancemmEditFieldLabel = uilabel(app.GridLayout3);
            app.ClearancemmEditFieldLabel.HorizontalAlignment = 'center';
            app.ClearancemmEditFieldLabel.FontSize = 15;
            app.ClearancemmEditFieldLabel.Layout.Row = 4;
            app.ClearancemmEditFieldLabel.Layout.Column = 1;
            app.ClearancemmEditFieldLabel.Text = 'Clearance (mm)';

            % Create ClearancemmEditField
            app.ClearancemmEditField = uieditfield(app.GridLayout3, 'numeric');
            app.ClearancemmEditField.Editable = 'off';
            app.ClearancemmEditField.Layout.Row = 4;
            app.ClearancemmEditField.Layout.Column = 2;

            % Create hydraulicTab
            app.hydraulicTab = uitab(app.TabGroup);
            app.hydraulicTab.Title = 'hydraulic';

            % Create GridLayout4
            app.GridLayout4 = uigridlayout(app.hydraulicTab);
            app.GridLayout4.RowHeight = {'1x', '1x', '1x', '1x'};

            % Create ClampingPressurebarEditFieldLabel
            app.ClampingPressurebarEditFieldLabel = uilabel(app.GridLayout4);
            app.ClampingPressurebarEditFieldLabel.HorizontalAlignment = 'center';
            app.ClampingPressurebarEditFieldLabel.FontSize = 15;
            app.ClampingPressurebarEditFieldLabel.Layout.Row = 2;
            app.ClampingPressurebarEditFieldLabel.Layout.Column = 1;
            app.ClampingPressurebarEditFieldLabel.Text = 'Clamping Pressure (bar)';

            % Create ClampingPressurebarEditField
            app.ClampingPressurebarEditField = uieditfield(app.GridLayout4, 'numeric');
            app.ClampingPressurebarEditField.Editable = 'off';
            app.ClampingPressurebarEditField.Layout.Row = 2;
            app.ClampingPressurebarEditField.Layout.Column = 2;

            % Create StrokemmEditFieldLabel
            app.StrokemmEditFieldLabel = uilabel(app.GridLayout4);
            app.StrokemmEditFieldLabel.HorizontalAlignment = 'center';
            app.StrokemmEditFieldLabel.FontSize = 15;
            app.StrokemmEditFieldLabel.Layout.Row = 1;
            app.StrokemmEditFieldLabel.Layout.Column = 1;
            app.StrokemmEditFieldLabel.Text = 'Stroke (mm)';

            % Create StrokemmEditField
            app.StrokemmEditField = uieditfield(app.GridLayout4, 'numeric');
            app.StrokemmEditField.Editable = 'off';
            app.StrokemmEditField.Layout.Row = 1;
            app.StrokemmEditField.Layout.Column = 2;

            % Create otherTab
            app.otherTab = uitab(app.TabGroup);
            app.otherTab.Title = 'other';

            % Create GridLayout5
            app.GridLayout5 = uigridlayout(app.otherTab);
            app.GridLayout5.RowHeight = {'1x', '1x', '1x', '1x'};

            % Create EccentricShaftAngleEditFieldLabel
            app.EccentricShaftAngleEditFieldLabel = uilabel(app.GridLayout5);
            app.EccentricShaftAngleEditFieldLabel.HorizontalAlignment = 'center';
            app.EccentricShaftAngleEditFieldLabel.FontSize = 15;
            app.EccentricShaftAngleEditFieldLabel.Layout.Row = 1;
            app.EccentricShaftAngleEditFieldLabel.Layout.Column = 1;
            app.EccentricShaftAngleEditFieldLabel.Text = 'Eccentric Shaft Angle';

            % Create EccentricShaftAngleEditField
            app.EccentricShaftAngleEditField = uieditfield(app.GridLayout5, 'numeric');
            app.EccentricShaftAngleEditField.Editable = 'off';
            app.EccentricShaftAngleEditField.Layout.Row = 1;
            app.EccentricShaftAngleEditField.Layout.Column = 2;

            % Create CuttingForcekNEditFieldLabel
            app.CuttingForcekNEditFieldLabel = uilabel(app.GridLayout5);
            app.CuttingForcekNEditFieldLabel.HorizontalAlignment = 'center';
            app.CuttingForcekNEditFieldLabel.FontSize = 15;
            app.CuttingForcekNEditFieldLabel.Layout.Row = 2;
            app.CuttingForcekNEditFieldLabel.Layout.Column = 1;
            app.CuttingForcekNEditFieldLabel.Text = 'Cutting Force (kN)';

            % Create CuttingForcekNEditField
            app.CuttingForcekNEditField = uieditfield(app.GridLayout5, 'numeric');
            app.CuttingForcekNEditField.Editable = 'off';
            app.CuttingForcekNEditField.Layout.Row = 2;
            app.CuttingForcekNEditField.Layout.Column = 2;

            % Create ClampingForcekNEditFieldLabel
            app.ClampingForcekNEditFieldLabel = uilabel(app.GridLayout5);
            app.ClampingForcekNEditFieldLabel.HorizontalAlignment = 'center';
            app.ClampingForcekNEditFieldLabel.FontSize = 15;
            app.ClampingForcekNEditFieldLabel.Layout.Row = 3;
            app.ClampingForcekNEditFieldLabel.Layout.Column = 1;
            app.ClampingForcekNEditFieldLabel.Text = 'Clamping Force (kN)';

            % Create ClampingForcekNEditField
            app.ClampingForcekNEditField = uieditfield(app.GridLayout5, 'numeric');
            app.ClampingForcekNEditField.Editable = 'off';
            app.ClampingForcekNEditField.Layout.Row = 3;
            app.ClampingForcekNEditField.Layout.Column = 2;

            % Create PositionSensorDifferencemmEditFieldLabel
            app.PositionSensorDifferencemmEditFieldLabel = uilabel(app.GridLayout5);
            app.PositionSensorDifferencemmEditFieldLabel.HorizontalAlignment = 'center';
            app.PositionSensorDifferencemmEditFieldLabel.FontSize = 15;
            app.PositionSensorDifferencemmEditFieldLabel.Layout.Row = 4;
            app.PositionSensorDifferencemmEditFieldLabel.Layout.Column = 1;
            app.PositionSensorDifferencemmEditFieldLabel.Text = 'Position Sensor Difference (mm)';

            % Create PositionSensorDifferencemmEditField
            app.PositionSensorDifferencemmEditField = uieditfield(app.GridLayout5, 'numeric');
            app.PositionSensorDifferencemmEditField.Editable = 'off';
            app.PositionSensorDifferencemmEditField.Layout.Row = 4;
            app.PositionSensorDifferencemmEditField.Layout.Column = 2;

            % Create proportionalValveTab
            app.proportionalValveTab = uitab(app.TabGroup);
            app.proportionalValveTab.Title = 'proportionalValve';

            % Create GridLayout6
            app.GridLayout6 = uigridlayout(app.proportionalValveTab);
            app.GridLayout6.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout6.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x'};

            % Create LeftValveGauge
            app.LeftValveGauge = uigauge(app.GridLayout6, 'ninetydegree');
            app.LeftValveGauge.Layout.Row = [1 3];
            app.LeftValveGauge.Layout.Column = [2 3];
            app.LeftValveGauge.Value = 100;

            % Create LeftValveGaugeLabel
            app.LeftValveGaugeLabel = uilabel(app.GridLayout6);
            app.LeftValveGaugeLabel.HorizontalAlignment = 'center';
            app.LeftValveGaugeLabel.Layout.Row = 4;
            app.LeftValveGaugeLabel.Layout.Column = [2 3];
            app.LeftValveGaugeLabel.Text = 'Left Valve';

            % Create RightValveGauge
            app.RightValveGauge = uigauge(app.GridLayout6, 'ninetydegree');
            app.RightValveGauge.Layout.Row = [1 3];
            app.RightValveGauge.Layout.Column = [8 9];
            app.RightValveGauge.Value = 100;

            % Create RightValveGaugeLabel
            app.RightValveGaugeLabel = uilabel(app.GridLayout6);
            app.RightValveGaugeLabel.HorizontalAlignment = 'center';
            app.RightValveGaugeLabel.Layout.Row = 4;
            app.RightValveGaugeLabel.Layout.Column = [8 9];
            app.RightValveGaugeLabel.Text = 'Right Valve';

            % Create PositionDifferenceSliderLabel
            app.PositionDifferenceSliderLabel = uilabel(app.GridLayout6);
            app.PositionDifferenceSliderLabel.HorizontalAlignment = 'center';
            app.PositionDifferenceSliderLabel.Layout.Row = 6;
            app.PositionDifferenceSliderLabel.Layout.Column = [4 7];
            app.PositionDifferenceSliderLabel.Text = 'Position Difference';

            % Create PositionDifferenceSlider
            app.PositionDifferenceSlider = uislider(app.GridLayout6);
            app.PositionDifferenceSlider.Limits = [-5 5];
            app.PositionDifferenceSlider.ValueChangingFcn = createCallbackFcn(app, @PositionDifferenceSliderValueChanging, true);
            app.PositionDifferenceSlider.Layout.Row = 5;
            app.PositionDifferenceSlider.Layout.Column = [4 7];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = operatorControlPanel_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end