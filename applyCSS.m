function [] = applyCSS(h,s)
    try
        if ~any(strcmp(javaclasspath,which('cssparser.jar')))
            javaaddpath(which('cssparser.jar'));
        end
        if ischar(h)
            h = get_param(h,'handle');
        end

        import java.io.Reader
        import com.steadystate.css.parser.*
        import org.w3c.dom.css.CSSStyleSheet
        import org.w3c.css.sac.InputSource

        special=struct('width',@setWidth,'height',@setHeight,'fontsize',@setFontSize);

        r = java.io.FileReader(which(s));
        parser = CSSOMParser(SACParserCSS3());
        is = InputSource(r);
        styleSheet = parser.parseStyleSheet(is, [], []);

        rules=getCssRules(styleSheet);

        for iRule=0:getLength(rules)-1
            rule=item(rules,iRule);
            selector=char(getSelectorText(rule));
            style=getStyle(rule);
            objects=selectobjects(h,selector)';
            for object=objects
                for iStyle=0:getLength(style)-1
                    myStyle=lower(char(item(style,iStyle)));

                    if ~isfield(special,myStyle)
                        value=parsevalue(char(getPropertyValue(style,myStyle)));
                        if isnumeric(value), value = mat2str(value); end
                        try
                            set(object,myStyle,value);
                        catch ex
                            %warning(ex.message)
                        end
                    else
                        f=special.(myStyle);
                        f(object,char(getPropertyValue(style,myStyle)));
                    end
                end
            end
        end
    catch ex
        % You're out of luck...
        warning(ex.message)
    end
end

function [ value ] = parsevalue( pv )
    if ~isempty(regexp(pv, ' ', 'once')) && isempty(regexp(pv, '^".*"$', 'once'))
        pv=['[' pv ']'];
    end
    if regexp(pv, '^".*"$')
        if isempty(regexp(pv, '^"\w+"$', 'once'))
            pv=pv(2:length(pv)-1);
        else
            pv=strrep(pv,'"','''');
        end
    end
    if regexp(pv, '^[^\d][\w]+$')
        pv=['''' pv ''''];
    end

    value=eval(pv);
end

function [ objects ] = selectobjects(parents,rule)
    objects=[];

    % Split comma delimiters
    rules=textscan(rule,'%s','delimiter',',');
    rules=rules{:};
    if length(rules) > 1
        for i=1:length(rules)
            objects=[objects;selectobjects(parents,rules{i})];
        end
        return
    else
        %continue
    end

    %myRule=strtok(rule,' ');
    toks=regexp(rule,'[^\s\[]+|\[[^\[\]]*\]','match');
    myRule=toks{1};

    id = regexp(myRule, '^\*?\#(?<name>\w+)', 'names');
    if ~isempty(id)
        if getversion >= 2012
            objects=[objects;find_system(parents,'includecommented','on','casesensitive','off','name',id.name)];
        else
            objects=[objects;find_system(parents,'casesensitive','off','name',id.name)];
        end
    end
    selector = regexp(myRule, '^\*?\:(?<prop>\w+)', 'names');
    if ~isempty(selector)
        if getversion >= 2012
            objects=[objects;find_system(parents,'includecommented','on','casesensitive','off',selector.prop,'on')];
        else
            objects=[objects;find_system(parents,'casesensitive','off',selector.prop,'on')];
        end
    end
    type = regexp(myRule, '^\*?\.(?<type>\w+)', 'names');
    if ~isempty(type)
        if getversion >= 2012
            objects=[objects;find_system(parents,'findall','on','includecommented','on','casesensitive','off','type',type.type)];
        else
            objects=[objects;find_system(parents,'findall','on','casesensitive','off','type',type.type)];
        end
    end
    blocktype = regexp(myRule, '^(?<blocktype>\w+)$', 'names');
    if ~isempty(blocktype)
        if getversion >= 2012
            objects=[objects;find_system(parents,'includecommented','on','casesensitive','off','blocktype',blocktype.blocktype)];
        else
            objects=[objects;find_system(parents,'casesensitive','off','blocktype',blocktype.blocktype)];
        end
    end    
    attr = regexp(myRule, '^\*?\[(?<Attr>\w+)="(?<Value>[^\[\]]*)"\]$', 'names');
    if ~isempty(attr)
        if getversion >= 2012
            objects=[objects;find_system(parents,'includecommented','on','casesensitive','off',attr.Attr,attr.Value)];
        else
            objects=[objects;find_system(parents,'casesensitive','off',attr.Attr,attr.Value)];
        end
    end
    attr = regexp(myRule, '^\*?\[(?<Attr>\w+)~="(?<Value>[^\[\]]*)"\]$', 'names');
    if ~isempty(attr)
        if getversion >= 2012            
            objects=[objects;setdiff(parents,find_system(parents,'includecommented','on','casesensitive','off',attr.Attr,attr.Value));];
        else
            objects=[objects;setdiff(parents,find_system(parents,'casesensitive','off',attr.Attr,attr.Value));];
        end
    end
    attr = regexp(myRule, '^\*?\[(?<Attr>\w+)\|="(?<Value>[^\[\]]*)"\]$', 'names');
    if ~isempty(attr)
        if getversion >= 2012
            objects=[objects;find_system(parents,'regexp','on','includecommented','on','casesensitive','off',attr.Attr,['^',attr.Value])];
        else
            objects=[objects;find_system(parents,'regexp','on','casesensitive','off',attr.Attr,['^',attr.Value])];
        end
    end
    attr = regexp(myRule, '^\*?\[(?<Attr>\w+)\*="(?<Value>[^\[\]]*)"\]$', 'names');
    if ~isempty(attr)
        if getversion >= 2012
            objects=[objects;find_system(parents,'regexp','on','includecommented','on','casesensitive','off',attr.Attr,attr.Value)];
        else
            objects=[objects;find_system(parents,'regexp','on','casesensitive','off',attr.Attr,attr.Value)];
        end
    end
    
    if regexp(myRule, '^\*$')
        if getversion >= 2012
            objects=[objects;find_system(parents,'includecommented','on','casesensitive','off')];
        else
            objects=[objects;find_system(parents,'casesensitive','off')];
        end
    end

    % Split space delimiters
    %rules=textscan(rule,'%s','delimiter',' ');
    %rules=rules{:};
    rules=toks;
    if length(rules) > 1
        for r=rules
            objects=selectobjects(objects,join(rules(2:end),' '));
        end
        return
    else
        % continue
    end
end

function result=join(c1,c2)
    result={};
    for i=1:length(c1)
        result{i}=[c1{i} c2];
    end
    result=[result{:}];
end

function []=setWidth(object,style)
	value=parsevalue(style);
    position = get_param(object,'position');
    position(3) = position(1)+value;
    try
        set_param(object,'Position',mat2str(position));
    catch ex
        %warning(ex.message)
    end
end

function []=setHeight(object,style)
	value=parsevalue(style);
    position = get_param(object,'position');
    position(4) = position(2)+value;
    try
        set_param(object,'Position',mat2str(position));
    catch ex
        %warning(ex.message)
    end
end

function []=setFontSize(object,style)
	value=parsevalue(style);
    try
        set_param(object,'FontSize',value);
        if strcmp(get(object,'type'),'annotation')
            new_text = regexprep(get(object,'Text'),'font-size:\d+px',sprintf('font-size:%dpx',value));
            set_param(object,'Text',new_text);
        end
    catch ex
        %warning(ex.message)
    end
end
