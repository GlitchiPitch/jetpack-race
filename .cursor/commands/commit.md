# /commit Command

**Description:** Performs a full commit cycle with documentation and game version updates

## Action Sequence

### 1. Documentation Update

* Check and update CHANGELOG.md
* Update TODO.md
* Check relevance of other documents in .dev/

### 2. Game Version Update

* Increment version in GameVersion.model.json
* Update version number in code (if applicable)
* Check version compatibility

### 3. Analysis and Planning

* Check task status in TODO.md
* Define next development steps
* Evaluate project progress
* Next steps: {plan for the next version}

### 4. Commit Creation

* Form commit message with new version
* Add all changes to index
* Execute commit with version description

## Commit Tags

```
[ Feature Review ], [ BugFix ], [ Test ], [ Complete ], [ Process ]
```

## Commit Format

```
- [ Tag ] [ v{X}.{Y}.{Z} ] [ github name ] Change 1
- [ Tag ] [ v{X}.{Y}.{Z} ] [ github name ] Change 2
```

*(emojis can be added)*
