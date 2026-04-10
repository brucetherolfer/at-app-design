import 'package:uuid/uuid.dart';
import '../models/blackout_window.dart';
import '../models/library.dart';
import '../models/prompt.dart';
import '../models/sequence.dart';

const _uuid = Uuid();

// Deterministic UID helpers for bodyscan sequence prompts.
// These must be stable so sequences can reference them by UID.
String _bsFullUid(int n) => 'bs_full_${n.toString().padLeft(3, '0')}';
String _bsJaUid(int n) => 'bs_ja_${n.toString().padLeft(3, '0')}';
String _bsJpUid(int n) => 'bs_jp_${n.toString().padLeft(3, '0')}';

// ── Libraries ──────────────────────────────────────────────────────────────

Library get allPromptsLibrary => Library()
  ..uid = 'builtin_all'
  ..name = 'All Prompts'
  ..isBuiltIn = true
  ..sortOrder = 0
  ..createdAt = DateTime(2024);

Library get brucesLibrary => Library()
  ..uid = 'builtin_bruces'
  ..name = "Bruce's Prompts"
  ..isBuiltIn = true
  ..sortOrder = 1
  ..createdAt = DateTime(2024);

Library get mioLibrary => Library()
  ..uid = 'builtin_mio'
  ..name = 'MIO Prompts'
  ..isBuiltIn = true
  ..sortOrder = 2
  ..createdAt = DateTime(2024);

Library get fmsDirectionsLibrary => Library()
  ..uid = 'builtin_fms_directions'
  ..name = "FM's Directions"
  ..isBuiltIn = true
  ..sortOrder = 3
  ..createdAt = DateTime(2024);

Library get fmsSequenceLibrary => Library()
  ..uid = 'builtin_fms_sequence'
  ..name = "FM's Sequence"
  ..isBuiltIn = true
  ..sortOrder = 4
  ..createdAt = DateTime(2024);

Library get modifiedClassicLibrary => Library()
  ..uid = 'builtin_modified'
  ..name = 'Classic AT — Modified'
  ..isBuiltIn = true
  ..sortOrder = 5
  ..createdAt = DateTime(2024);

Library get bodyscanFullLibrary => Library()
  ..uid = 'builtin_bs_full'
  ..name = 'Bodyscan — Full'
  ..isBuiltIn = true
  ..sortOrder = 5
  ..createdAt = DateTime(2024);

Library get bodyscanJointsAnatLibrary => Library()
  ..uid = 'builtin_bs_joints_anat'
  ..name = 'Bodyscan — Joints (Anatomical)'
  ..isBuiltIn = true
  ..sortOrder = 6
  ..createdAt = DateTime(2024);

Library get bodyscanJointsPlainLibrary => Library()
  ..uid = 'builtin_bs_joints_plain'
  ..name = 'Bodyscan — Joints (Plain Language)'
  ..isBuiltIn = true
  ..sortOrder = 7
  ..createdAt = DateTime(2024);

Library get questionsLibrary => Library()
  ..uid = 'builtin_questions'
  ..name = 'Questions'
  ..isBuiltIn = true
  ..sortOrder = 8
  ..createdAt = DateTime(2024);

// ── All Prompts (197) ──────────────────────────────────────────────────────
// Source: All_Prompts spreadsheet. Full AT awareness prompt set.

List<Prompt> get allPrompts {
  final texts = [
    'Let the neck be free.',
    'Allow the head to go forward and up.',
    'Let the back lengthen.',
    'Let the back widen.',
    'Allow the shoulders to release out to the sides.',
    'Soften the jaw.',
    'Let the tongue rest wide in the mouth.',
    'Release the eyes in their sockets.',
    'Allow breath to come and go.',
    'Pause before you move.',
    'Notice unnecessary effort.',
    'Stop trying to fix yourself.',
    'Let the floor support you.',
    'Let the chair take your weight.',
    'Allow the sit bones to release downward.',
    'Let the ribs move freely.',
    'Think space between vertebrae.',
    'Allow the head to balance easily.',
    'Let gravity do the work.',
    'Widen across the collarbones.',
    'Let the arms hang from the back.',
    'Allow the hands to be light.',
    'Soften the neck before speaking.',
    'Let the head lead the movement.',
    'Allow length through the whole spine.',
    'Let the knees go forward and away.',
    'Release the hips without pushing.',
    'Think up without stiffening.',
    'Allow ease, not effort.',
    'Notice where you are holding.',
    'Choose not to tighten.',
    'Let go of good posture.',
    'Allow coordination to happen.',
    'Let movement emerge.',
    'Let the back stay wide as you sit.',
    'Allow the head to float.',
    'Trust the support beneath you.',
    'Let your breathing organize itself.',
    'Pause at the start of action.',
    'Allow length before movement.',
    'Reduce excess muscle tone.',
    'Let the chest be soft.',
    'Allow the spine to be springy.',
    'Think direction, not position.',
    'Let the body be curious.',
    'Release downward without collapsing.',
    'Allow balance, not control.',
    'Let the neck release when stressed.',
    'Widen your awareness beyond yourself.',
    'Include the whole room.',
    'Let your weight distribute evenly.',
    'Think of the head as light.',
    'Let effort drain out.',
    'Allow your body to organize.',
    'Soften the front of the neck.',
    'Let the back breathe.',
    'Choose ease over habit.',
    'Let the spine lengthen upward.',
    'Allow width through the pelvis.',
    'Release the shoulders down and wide.',
    'Let the feet rest on the ground.',
    'Allow the knees to unlock.',
    'Let the neck lead all movement.',
    'Think up without strain.',
    'Stop forcing alignment.',
    'Let coordination replace control.',
    'Allow stillness inside movement.',
    'Pause, then proceed.',
    'Let go of end-gaining.',
    'Allow means to matter.',
    'Think freedom first.',
    'Let the body respond.',
    'Soften before you act.',
    'Allow space in the joints.',
    'Let tension dissolve downward.',
    'Keep the head free as you walk.',
    'Allow the back to support the limbs.',
    'Reduce effort in the neck.',
    'Let the torso widen as you breathe.',
    'Allow the spine to lengthen naturally.',
    'Notice and release gripping.',
    'Let the body feel supported.',
    'Allow balance to be dynamic.',
    'Think ease through transitions.',
    'Let your attention be wide.',
    'Allow movement to be simple.',
    'Trust natural coordination.',
    'Let go of over-doing.',
    'Allow clarity instead of force.',
    'Keep direction; drop tension.',
    'Let your weight flow downward.',
    'Allow the head to lead forward and up.',
    'Choose softness over stiffness.',
    'Let the back widen again.',
    'Release, then move.',
    'Allow less effort, more length.',
    'Stop. Think. Direct.',
    'Is your neck free?',
    'Let your head float up.',
    'Are your shoulders dropping away from your ears?',
    'Notice the weight of your head.',
    'Is your jaw clenched?',
    'Let your back lengthen and widen.',
    'Where is your weight right now?',
    'Is your breathing restricted anywhere?',
    'Let your knees go forward and away.',
    'Notice your contact with the ground.',
    'Is your chest collapsed?',
    'Let your spine decompress.',
    'Are you gripping with your hands?',
    'Notice the space behind your eyes.',
    'Is your tongue pressed to the roof of your mouth?',
    'Let your shoulders widen.',
    'Are you bracing your legs?',
    'Notice your lower back — is it compressed?',
    'Let your head lead, body follow.',
    'Are you holding your breath?',
    'Notice the width of your upper back.',
    'Is your pelvis tucked or tilted?',
    'Let your arms hang freely.',
    'Are you squinting?',
    'Notice the length of your spine.',
    'Is your neck shortening?',
    'Let your ribs move with your breath.',
    'Are you pulling your head back?',
    'Notice the softness behind your knees.',
    'Is your belly gripping?',
    'Let your face soften.',
    'Are your toes curled?',
    'Notice the relationship between your head and atlas.',
    'Is your sternum lifting?',
    'Let your sitting bones drop.',
    'Are you leaning into one hip?',
    'Notice the space between your vertebrae.',
    'Is your chin jutting forward?',
    'Let your eyes soften and widen.',
    'Are you rushing?',
    'Notice the weight dropping through your heels.',
    'Is your upper chest tight?',
    'Let your neck be long.',
    'Are your hands tense?',
    'Notice the horizon line of your eyes.',
    'Is your head tipped to one side?',
    'Let your breath come to you.',
    'Are you end-gaining right now?',
    'Notice the primary control.',
    'Is your back narrowing?',
    'Let your ankles be free.',
    'Are you over-efforting?',
    'Notice the ease available to you.',
    'Is your head balanced on your spine?',
    'Let your lower back soften.',
    'Are you bracing your core?',
    'Notice the length from crown to tailbone.',
    'Is your throat constricted?',
    'Let your hips release.',
    'Are you pulling down?',
    'Notice inhibition — pause before acting.',
    'Are your neck muscles tight?',
    'Let your weight be supported.',
    'Are you lifting your chest unnecessarily?',
    'Notice if you\'re anticipating the next thing.',
    'Is your head free to nod?',
    'Let your shoulder blades slide down your back.',
    'Are you contracting to stay upright?',
    'Notice the direction of your gaze.',
    'Is your lower jaw hanging free?',
    'Let your whole back breathe.',
    'Are you gripping the floor with your feet?',
    'Notice where effort is unnecessary.',
    'Is your sternum compressed?',
    'Let your arms lengthen from your back.',
    'Are you pulling your shoulders forward?',
    'Notice the relationship of your ears to your shoulders.',
    'Is your breathing shallow?',
    'Let your neck release forward and up.',
    'Are you holding tension in your forehead?',
    'Notice your head as a weight balanced on your spine.',
    'Is your mid-back collapsing?',
    'Let your entire spine be involved in movement.',
    'Are you fixing your gaze too hard?',
    'Notice the ease in your peripheral vision.',
    'Is your weight forward on your toes?',
    'Let your skull float away from your atlas.',
    'Are you bracing for something that isn\'t happening?',
    'Notice the space between your shoulder blades.',
    'Is your neck shortening as you think?',
    'Let your whole self be taller.',
    'Are you compressing downward as you sit?',
    'Notice the relationship between your eyes and your neck.',
    'Is your upper arm rotating inward?',
    'Let your ribs be free to expand sideways.',
    'Are you rushing through this moment?',
    'Notice the quality of your attention right now.',
    'Is your sacrum tucked under?',
    'Let your whole back surface widen and lengthen.',
    'Pause. Inhibit. Direct. Move.',
  ];
  return texts.asMap().entries.map((e) {
    return Prompt()
      ..uid = _uuid.v4()
      ..text = e.value
      ..libraryUid = 'builtin_all'
      ..sortOrder = e.key
      ..isBuiltIn = true
      ..createdAt = DateTime(2024);
  }).toList();
}

// ── Bruce's Prompts (44) ───────────────────────────────────────────────────
// Source: Bruce's Prompts spreadsheet.

List<Prompt> get brucesPrompts {
  final texts = [
    'Let your gaze be soft.',
    'Practice all-inclusive awareness.',
    'Let your ribs be soft as you breathe.',
    'Let your front be long from your pubic bone to your supersternal notch.',
    'Let your shoulders be wide all the way across your collarbones.',
    'Let your neck be free.',
    'Let your neck be free so your head can move forward and up.',
    'Let your neck be free so your head can move forward and up, your back can lengthen and widen, and your legs and arms can lengthen through your fingers and toes.',
    'Let your ribs be free.',
    'Let your eyes be free.',
    'Let your face be free.',
    'Let your jaw be free.',
    'Are you gripping the floor?',
    'Are you compressing your abdomen?',
    'Are you bending at your waist?',
    'Notice the space behind your head.',
    'Notice the space above your head.',
    'Notice the hair on the back of your head.',
    'Notice the hair on the top of your head.',
    'Notice the space behind your neck.',
    'Notice the hair on the back of your neck.',
    'Let your breath move.',
    'Let your body move.',
    'Notice the space all around you.',
    'Notice what you can see in your periphery.',
    'How can I pay attention that will make me release just a little bit?',
    'What can I pay attention to that will make me release just a little bit?',
    'What way of paying attention makes me more whole and complete and easier and more flexible?',
    'What\'s the least amount of effort I can use to initiate some easing?',
    'What place am I tightening?',
    'What place is getting easier?',
    'Whisper the directions.',
    'What\'s the least amount I can ease or let go?',
    'Can you notice in such a way that you get easier?',
    'If you catch yourself noticing tension, move awareness to the space above your head or to an easier place.',
    'Where else do I seem to be easing a bit?',
    'Are you pushing your pelvis forward?',
    'Are you drawing your shoulders together?',
    'Are you letting your feet rest on the ground?',
    'Are you leaning your pelvis to one side?',
    'Are you pushing your knees back?',
    'Are your shoulders lifted up or down?',
    'Anything you do you\'ll eventually have to undo.',
    'Anything you do you\'ll eventually have to stop doing.',
  ];
  return texts.asMap().entries.map((e) {
    return Prompt()
      ..uid = _uuid.v4()
      ..text = e.value
      ..libraryUid = 'builtin_bruces'
      ..sortOrder = e.key
      ..isBuiltIn = true
      ..createdAt = DateTime(2024);
  }).toList();
}

// ── MIO Prompts (16) ──────────────────────────────────────────────────────
// Source: MIO Prompts spreadsheet.

List<Prompt> get mioPrompts {
  final texts = [
    'Where are you easing a little bit?',
    'What is happening to the ease in your body?',
    'Notice the ease in your body.',
    'Notice a little bit of ease.',
    'Notice if anything is easing a little bit.',
    'Notice a place that feels relatively better.',
    'Notice, think, notice, move, notice.',
    'Your feet are a long way away.',
    'Sharks have no shoulders.',
    'Legs and hips far away.',
    'Where are you getting a little easier?',
    'Inhibit responding to your thoughts.',
    'Above.',
    'Where do you notice ease?',
    'You can only do it right now.',
    'Where else do you seem to be easing a bit?',
  ];
  return texts.asMap().entries.map((e) {
    return Prompt()
      ..uid = _uuid.v4()
      ..text = e.value
      ..libraryUid = 'builtin_mio'
      ..sortOrder = e.key
      ..isBuiltIn = true
      ..createdAt = DateTime(2024);
  }).toList();
}

// ── FM's Directions (1 prompt — full combined direction) ──────────────────

List<Prompt> get fmsDirectionsPrompts => [
  Prompt()
    ..uid = 'fms_dir_001'
    ..text = "Let your neck be free. So your head can go forward and up. The back can lengthen and widen and your knees go forward and away."
    ..libraryUid = 'builtin_fms_directions'
    ..sortOrder = 0
    ..isBuiltIn = true
    ..createdAt = DateTime(2024),
];

// ── FM's Sequence (4 prompts — split for sequential delivery) ─────────────

List<Prompt> get fmsSequencePrompts => [
  Prompt()
    ..uid = 'fms_seq_001'
    ..text = "Let your neck be free."
    ..libraryUid = 'builtin_fms_sequence'
    ..sortOrder = 0
    ..isBuiltIn = true
    ..createdAt = DateTime(2024),
  Prompt()
    ..uid = 'fms_seq_002'
    ..text = "So your head can go forward and up."
    ..libraryUid = 'builtin_fms_sequence'
    ..sortOrder = 1
    ..isBuiltIn = true
    ..createdAt = DateTime(2024),
  Prompt()
    ..uid = 'fms_seq_003'
    ..text = "The back can lengthen and widen."
    ..libraryUid = 'builtin_fms_sequence'
    ..sortOrder = 2
    ..isBuiltIn = true
    ..createdAt = DateTime(2024),
  Prompt()
    ..uid = 'fms_seq_004'
    ..text = "And your knees go forward and away."
    ..libraryUid = 'builtin_fms_sequence'
    ..sortOrder = 3
    ..isBuiltIn = true
    ..createdAt = DateTime(2024),
];

// ── Classic AT — Modified Prompts (13) ────────────────────────────────────
// Source: Classic AT - Modified Prompts spreadsheet. Contemporary adaptations.

List<Prompt> get modifiedClassicPrompts {
  final texts = [
    'Let your neck be free.',
    'So your head can move forward and up.',
    'Your back can lengthen.',
    'And widen.',
    'And your knees can go forward and away.',
    'And your legs and arms can lengthen through your fingers and toes.',
    'Let your neck be free, so your head can move forward and up, your back can lengthen and widen, your knees can go forward and away, and your legs and arms can lengthen through your fingers and toes.',
    'Let your neck be free so your head can go forward and up and your back can lengthen and widen and your arms and legs can lengthen through your elbows, knees, fingers and toes.',
    'Let your neck free, let your head forward and up, let your back lengthen and widen.',
    'Let your neck be free, let your head forward and up a tiny bit.',
    'Let your head go forward and up imperceptibly.',
    'Head leads, body follows.',
    'Let your neck be free, your back lengthen and widen out your shoulders, elbows and fingers, out your hips, knees, ankles and toes.',
  ];
  return texts.asMap().entries.map((e) {
    return Prompt()
      ..uid = _uuid.v4()
      ..text = e.value
      ..libraryUid = 'builtin_modified'
      ..sortOrder = e.key
      ..isBuiltIn = true
      ..createdAt = DateTime(2024);
  }).toList();
}

// ── Bodyscan Full (48) ────────────────────────────────────────────────────
// Source: Bodyscan Full spreadsheet.
// Uses deterministic UIDs so the bodyscanFullSequence can reference them.

List<Prompt> get bodyscanFullPrompts {
  final texts = [
    'Let the top of your head be free.',
    'Let your forehead be free.',
    'Let the back of your head be free.',
    'Let the sides of your head be free.',
    'Let your eyebrows be free.',
    'Let your ears be free.',
    'Let your eyes be free.',
    'Let your nose be free.',
    'Let your temples be free.',
    'Let your cheeks be free.',
    'Let your lips and mouth be free.',
    'Let your jaw be free.',
    'Let the front, back, and sides of your neck be free.',
    'Let your shoulders be free.',
    'Let your sternum and chest be free.',
    'Let your shoulder blades and mid back be free.',
    'Let your upper arms be free.',
    'Let your elbows be free.',
    'Let your forearms be free.',
    'Let your wrists be free.',
    'Let your hands, thumbs, index, middle, ring, and pinky fingers be free.',
    'Let your solar plexus be free.',
    'Let your armpits be free.',
    'Let your abdomen be free.',
    'Let your diaphragm be free.',
    'Let your lower back be free.',
    'Let your sides be free.',
    'Let your pubic bone be free.',
    'Let your groin be free.',
    'Let your hips be free.',
    'Let your glutes be free.',
    'Let your perineum, anus, and private parts be free.',
    'Let your sit bones be free.',
    'Let the front, back, and sides of your thighs be free.',
    'Let your knees, kneecaps, and the back and sides of your knees be free.',
    'Let your shins be free.',
    'Let your calves be free.',
    'Let your Achilles be free.',
    'Let the inside, outside, front, and back of your ankles be free.',
    'Let the tops of your feet be free.',
    'Let the bottoms of your feet be free.',
    'Let your heels be free — the edges, the back, and all sides.',
    'Let the balls of your feet be free, from the big toe to the pinky.',
    'Let your big toe be free.',
    'Let your second toe be free.',
    'Let your middle toe be free.',
    'Let your fourth toe be free.',
    'Let your little toe be free.',
  ];
  return texts.asMap().entries.map((e) {
    return Prompt()
      ..uid = _bsFullUid(e.key + 1)
      ..text = e.value
      ..libraryUid = 'builtin_bs_full'
      ..sortOrder = e.key
      ..isBuiltIn = true
      ..createdAt = DateTime(2024);
  }).toList();
}

// ── Bodyscan Joints — Anatomical (29) ─────────────────────────────────────
// Source: Bodyscan Joints spreadsheet, anatomical language column.
// Uses deterministic UIDs for sequence cross-referencing.

List<Prompt> get bodyscanJointsAnatPrompts {
  final texts = [
    'Let your atlanto-occipital joint be free.',
    'Let your atlantoaxial joint be free.',
    'Let your jaw be free.',
    'Let your cervical spine joints be free.',
    'Let your thoracic spine joints be free.',
    'Let your rib joints be free.',
    'Let your sternocostal joints be free.',
    'Let your sternoclavicular joints be free.',
    'Let your AC joints be free.',
    'Let your shoulder joints be free.',
    'Let your shoulder blades be free.',
    'Let your elbows be free.',
    'Let your forearm joints be free.',
    'Let your wrists be free.',
    'Let your knuckles be free.',
    'Let your finger joints be free.',
    'Let your thumb joint be free.',
    'Let your lumbar spine joints be free.',
    'Let your lumbosacral joint be free.',
    'Let your SI joints be free.',
    'Let your pubic symphysis be free.',
    'Let your hip joints be free.',
    'Let your knee joints be free.',
    'Let your kneecaps be free.',
    'Let your ankles be free.',
    'Let your subtalar joints be free.',
    'Let your midfoot joints be free.',
    'Let the balls of your feet be free.',
    'Let your toe joints be free.',
  ];
  return texts.asMap().entries.map((e) {
    return Prompt()
      ..uid = _bsJaUid(e.key + 1)
      ..text = e.value
      ..libraryUid = 'builtin_bs_joints_anat'
      ..sortOrder = e.key
      ..isBuiltIn = true
      ..createdAt = DateTime(2024);
  }).toList();
}

// ── Bodyscan Joints — Plain Language (29) ─────────────────────────────────
// Source: Bodyscan Joints spreadsheet, plain language column.
// Uses deterministic UIDs for sequence cross-referencing.

List<Prompt> get bodyscanJointsPlainPrompts {
  final texts = [
    'Let the joint between your neck and head, the space between your ears, be free.',
    'Let the joint that lets you shake your head no be free.',
    'Let your jaw be free.',
    'Let your neck joints be free.',
    'Let your thoracic spine joints be free.',
    'Let the rib joints be free at the back where they attach to the spine.',
    'Let the rib joints be free at the front where they attach to the sternum.',
    'Let the collarbone be free at the sternum and the shoulder blade.',
    'Let the collarbone be free at the shoulder blade.',
    'Let the upper arm be free at the shoulder joint.',
    'Let your shoulder blades be free.',
    'Let the elbow be free.',
    'Let the forearm joints be free.',
    'Let the wrist be free.',
    'Let the joints of the palm and fingers be free.',
    'Let the finger joints be free.',
    'Let the thumb joint be free.',
    'Let your lower back joints be free.',
    'Let the joint between the rib vertebra and the low back vertebra be free.',
    'Let your SI joints be free.',
    'Let your pubic symphysis be free.',
    'Let the hip joints be free.',
    'Let the knee joints be free.',
    'Let the kneecaps be free.',
    'Let the ankles be free.',
    'Let the joints of the foot and heel be free.',
    'Let the midfoot joints be free.',
    'Let the joints of the foot and toes be free.',
    'Let the toe joints be free.',
  ];
  return texts.asMap().entries.map((e) {
    return Prompt()
      ..uid = _bsJpUid(e.key + 1)
      ..text = e.value
      ..libraryUid = 'builtin_bs_joints_plain'
      ..sortOrder = e.key
      ..isBuiltIn = true
      ..createdAt = DateTime(2024);
  }).toList();
}

// ── Questions (88) ────────────────────────────────────────────────────────
// Awareness check-in questions.

List<Prompt> get questionsPrompts {
  final texts = [
    'Is your neck free?',
    'Are your shoulders dropping away from your ears?',
    'Is your jaw clenched?',
    'Where is your weight right now?',
    'Is your breathing restricted anywhere?',
    'Is your chest collapsed?',
    'Are you gripping with your hands?',
    'Is your tongue pressed to the roof of your mouth?',
    'Are you bracing your legs?',
    'Notice your lower back — is it compressed?',
    'Are you holding your breath?',
    'Is your pelvis tucked or tilted?',
    'Are you squinting?',
    'Is your neck shortening?',
    'Are you pulling your head back?',
    'Is your belly gripping?',
    'Are your toes curled?',
    'Is your sternum lifting?',
    'Are you leaning into one hip?',
    'Is your chin jutting forward?',
    'Are you rushing?',
    'Is your upper chest tight?',
    'Are your hands tense?',
    'Is your head tipped to one side?',
    'Are you end-gaining right now?',
    'Is your back narrowing?',
    'Are you over-efforting?',
    'Is your head balanced on your spine?',
    'Are you bracing your core?',
    'Is your throat constricted?',
    'Are you pulling down?',
    'Are your neck muscles tight?',
    'Are you lifting your chest unnecessarily?',
    'Is your head free to nod?',
    'Are you contracting to stay upright?',
    'Is your lower jaw hanging free?',
    'Is your sternum compressed?',
    'Are you pulling your shoulders forward?',
    'Is your breathing shallow?',
    'Are you holding tension in your forehead?',
    'Is your mid-back collapsing?',
    'Are you fixing your gaze too hard?',
    'Is your weight forward on your toes?',
    'Are you bracing for something that isn\'t happening?',
    'Is your neck shortening as you think?',
    'Are you compressing downward as you sit?',
    'Is your upper arm rotating inward?',
    'Are you rushing through this moment?',
    'Is your sacrum tucked under?',
    'Are you gripping the floor?',
    'Are you compressing your abdomen?',
    'Are you bending at your waist?',
    'Is your abdomen compressed?',
    'Is your abdomen collapsed?',
    'Is your solar plexus compressed?',
    'Is your solar plexus collapsed?',
    'Are your toes clenched?',
    'Are your ankles held?',
    'Are your feet clenched?',
    'Where are you easing a little bit?',
    'What is happening to the ease in your body?',
    'Are you holding?',
    'Are you gripping?',
    'Are you clenching?',
    'Are you tightening?',
    'Are you heavy?',
    'Are you light?',
    'Are you compressing?',
    'Are you shrinking?',
    'Are you noticing the space around you?',
    'Are you bracing?',
    'Are you tensing?',
    'Are you shortening?',
    'Are you stiffening?',
    'Are you locking?',
    'Are you guarding?',
    'Are you collapsing?',
    'Are you pulling in?',
    'Are you sinking?',
    'Are you floating?',
    'Are you rising?',
    'Are you clutching?',
    'Are you squeezing?',
    'Are you hardening?',
    'Are you narrowing?',
    'Are you shortening?',
    'Are you withdrawing?',
    'Are you curling in?',
    'Are you hunching?',
  ];
  return texts.asMap().entries.map((e) {
    return Prompt()
      ..uid = _uuid.v4()
      ..text = e.value
      ..libraryUid = 'builtin_questions'
      ..sortOrder = e.key
      ..isBuiltIn = true
      ..createdAt = DateTime(2024);
  }).toList();
}

// ── Built-in Sequences ─────────────────────────────────────────────────────

/// Primary Control — promptUids populated by user once final prompt text is confirmed.
Sequence get primaryControlSequence => Sequence()
  ..uid = 'builtin_seq_primary_control'
  ..name = 'Primary Control'
  ..promptUids = []
  ..gapSeconds = 2
  ..isBuiltIn = true
  ..createdAt = DateTime(2024);

/// Bodyscan Full — 48 prompts, head to toe.
Sequence get bodyscanFullSequence => Sequence()
  ..uid = 'builtin_seq_bs_full'
  ..name = 'Bodyscan — Full'
  ..promptUids = List.generate(48, (i) => _bsFullUid(i + 1))
  ..gapSeconds = 4
  ..isBuiltIn = true
  ..createdAt = DateTime(2024);

/// Bodyscan Joints — Anatomical (29 prompts).
Sequence get bodyscanJointsAnatSequence => Sequence()
  ..uid = 'builtin_seq_bs_joints_anat'
  ..name = 'Bodyscan — Joints (Anatomical)'
  ..promptUids = List.generate(29, (i) => _bsJaUid(i + 1))
  ..gapSeconds = 4
  ..isBuiltIn = true
  ..createdAt = DateTime(2024);

/// Bodyscan Joints — Plain Language (29 prompts).
Sequence get bodyscanJointsPlainSequence => Sequence()
  ..uid = 'builtin_seq_bs_joints_plain'
  ..name = 'Bodyscan — Joints (Plain Language)'
  ..promptUids = List.generate(29, (i) => _bsJpUid(i + 1))
  ..gapSeconds = 4
  ..isBuiltIn = true
  ..createdAt = DateTime(2024);

// ── Default Blackout Windows ──────────────────────────────────────────────

/// Sleep window — 10pm to 7am, all days, disabled by default.
/// Shows up in Blackout Windows on first launch as a shell the user can enable.
BlackoutWindow get sleepBlackoutWindow => BlackoutWindow()
  ..uid = 'builtin_blackout_sleep'
  ..label = 'Sleep'
  ..daysOfWeek = [1, 2, 3, 4, 5, 6, 7]
  ..startTime = '22:00'
  ..endTime = '07:00'
  ..isEnabled = false;
