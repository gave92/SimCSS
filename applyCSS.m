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

        special=struct('width',@setWidth,'height',@setHeight);

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
                            set_param(object,myStyle,value);
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

    myRule=strtok(rule,' ');

    id = regexp(myRule, '^\*?\#(?<name>\w+)', 'names');
    if ~isempty(id)
        objects=[objects;find_system(parents,'includecommented','on','casesensitive','off','name',id.name)];
    end
    selector = regexp(myRule, '^\*?\:(?<prop>\w+)', 'names');
    if ~isempty(selector)
        objects=[objects;find_system(parents,'includecommented','on','casesensitive','off',selector.prop,'on')];
    end
    type = regexp(myRule, '^\*?\.(?<type>\w+)', 'names');
    if ~isempty(type)
        objects=[objects;find_system(parents,'findall','on','includecommented','on','casesensitive','off','type',type.type)];
    end
    blocktype = regexp(myRule, '^(?<blocktype>\w+)$', 'names');
    if ~isempty(blocktype)
        objects=[objects;find_system(parents,'includecommented','on','casesensitive','off','blocktype',blocktype.blocktype)];
    end    
    attr = regexp(myRule, '^\*?\[(?<Attr>\w+)="(?<Value>\w+)"\]$', 'names');
    if ~isempty(attr)
        objects=[objects;find_system(parents,'includecommented','on','casesensitive','off',attr.Attr,attr.Value)];
    end
    attr = regexp(myRule, '^\*?\[(?<Attr>\w+)\|="(?<Value>\w+)"\]$', 'names');
    if ~isempty(attr)
        objects=[objects;find_system(parents,'regexp','on','includecommented','on','casesensitive','off',attr.Attr,['^',attr.Value])];
    end
    attr = regexp(myRule, '^\*?\[(?<Attr>\w+)\*="(?<Value>\w+)"\]$', 'names');
    if ~isempty(attr)
        objects=[objects;find_system(parents,'regexp','on','includecommented','on','casesensitive','off',attr.Attr,attr.Value)];
    end
    
    if regexp(myRule, '^\*$')
        objects=[objects;find_system(parents,'includecommented','on','casesensitive','off')];
    end

    % Split space delimiters
    rules=textscan(rule,'%s','delimiter',' ');
    rules=rules{:};
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

